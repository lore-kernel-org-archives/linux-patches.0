Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C4776044;
	Mon, 15 Apr 2024 14:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191527; cv=none; b=UY+HYc6+iGvTycgHz1MrO6HH18QFUB8zFSLkc/gIwJXYmvGbiKHHWWquZk7Mh3GzO1WXZMXZRugtI8MckySG64qjDb1rHkPen8eEIq/BnvDEeTSNwebCaUElknNCw8dkcUHoMJXrhWcB7INagMaIJjTJsGba1dChU4b4mj6CwbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191527; c=relaxed/simple;
	bh=hqriBvCNqPFtaQu3djPavsPyXafvaq4giZKBVZ/cL5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nS0hHhRdt8ir08qoEYaZlOUO5/OPNByOtGXnkG4lSc+DAuQOhObsMnnN6oK9avYg+6kE+fuYONhxjRPozYtKhTLFxyow4r13edp3yhC4ng7ZEIsf0cr6wmPj9bJRdOXXRZvCbHBe3CGzhlb+AyeT8HNkjZVN+filvTH/c/qHfBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpjaJTj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpjaJTj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43514C113CC;
	Mon, 15 Apr 2024 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191527;
	bh=hqriBvCNqPFtaQu3djPavsPyXafvaq4giZKBVZ/cL5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpjaJTj1crhSMP1+tkvlXSlusk/ihf1hIfXR4arWX1TnvKdJ9EdjR16y8GAKCcdI/
	 9nQq2WNvqNIwOSmtP2ngUkzVqDIn0KzNbZHUgyp4WO+Gnyep9/nk/ADVbD8rjlNFGa
	 tufqMSvorvNBLGCM1XdW3gTIyR1FCJFcw0fLYlhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 171/172] drm/amd/display: always reset ODM mode in context when adding first plane
Date: Mon, 15 Apr 2024 16:21:10 +0200
Message-ID: <20240415142005.538891219@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjing Liu <wenjing.liu@amd.com>

commit 81901d8d0472e9a19d294ae1dea76b950548195d upstream.

[why]
In current implemenation ODM mode is only reset when the last plane is
removed from dc state. For any dc validate we will always remove all
current planes and add new planes. However when switching from no planes
to 1 plane, ODM mode is not reset because no planes get removed. This
has caused an issue where we kept ODM combine when it should have been
remove when a plane is added. The change is to reset ODM mode when
adding the first plane.

Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_state.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_state.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_state.c
@@ -436,6 +436,15 @@ bool dc_state_add_plane(
 		goto out;
 	}
 
+	if (stream_status->plane_count == 0 && dc->config.enable_windowed_mpo_odm)
+		/* ODM combine could prevent us from supporting more planes
+		 * we will reset ODM slice count back to 1 when all planes have
+		 * been removed to maximize the amount of planes supported when
+		 * new planes are added.
+		 */
+		resource_update_pipes_for_stream_with_slice_count(
+				state, dc->current_state, dc->res_pool, stream, 1);
+
 	otg_master_pipe = resource_get_otg_master_for_stream(
 			&state->res_ctx, stream);
 	if (otg_master_pipe)


