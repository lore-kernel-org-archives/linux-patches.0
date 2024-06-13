Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9E3DDB1;
	Thu, 13 Jun 2024 11:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278801; cv=none; b=DNOyd8PhktcV3H7DraHLFoTpf+QPBZHmO63Cfppvbxo4nIQW2eDlHsOUbSa3G6CYNCYPDbKzFlBXsQAFW6mrIvbNYIjXLI1OcahU/kLS0QZX2guezyw27i0G1CXQA950Pb2/4QwkWbWrs7AJ4tfn9eChQ70rKhKSJhg0r2Y2EHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278801; c=relaxed/simple;
	bh=TJHkh3xJ6WvTsjU+jVyWIkTIEBRG+2WOY0nv32Xn9aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASQrsF3JoScHFI/J2++z0DkDDceGG8Q8xBJcZk4loKHnjV78HH+YxoKr0jl/Rkt2YTDFqYoZOnmNO8nJ3T9yPFLPrSblBfD+FTSnrU9gtDo3KeDOOi4lJWJuc9S1Ok8UsRmJIF9n6Rmd4jhy0SXwEiC0yzKWtpP5vRJZhJNmEBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7A9xNsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7A9xNsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626BFC2BBFC;
	Thu, 13 Jun 2024 11:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278801;
	bh=TJHkh3xJ6WvTsjU+jVyWIkTIEBRG+2WOY0nv32Xn9aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7A9xNsvaYRPzaz+zh0Rm6V/0Ng4mVVjf2GJj3ez33xH1qbegx7Of+c2MMkiXFp65
	 Uf81XmYtqFLvn6lLHkrdz5cZXTXSgd5iODQao2ktTvPd+k8EAo4+/JG0euJ7ulJBkg
	 7EWIuIbigA7Vry2HT0wBO74U2xkjVIKX1HW0dJRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/213] drm/arm/malidp: fix a possible null pointer dereference
Date: Thu, 13 Jun 2024 13:32:02 +0200
Message-ID: <20240613113230.863117415@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huai-Yuan Liu <qq810974084@gmail.com>

[ Upstream commit a1f95aede6285dba6dd036d907196f35ae3a11ea ]

In malidp_mw_connector_reset, new memory is allocated with kzalloc, but
no check is performed. In order to prevent null pointer dereferencing,
ensure that mw_state is checked before calling
__drm_atomic_helper_connector_reset.

Fixes: 8cbc5caf36ef ("drm: mali-dp: Add writeback connector")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240407063053.5481-1-qq810974084@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_mw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
index 7266d3c8b8f41..420efbdea76c3 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -69,7 +69,10 @@ static void malidp_mw_connector_reset(struct drm_connector *connector)
 		__drm_atomic_helper_connector_destroy_state(connector->state);
 
 	kfree(connector->state);
-	__drm_atomic_helper_connector_reset(connector, &mw_state->base);
+	connector->state = NULL;
+
+	if (mw_state)
+		__drm_atomic_helper_connector_reset(connector, &mw_state->base);
 }
 
 static enum drm_connector_status
-- 
2.43.0



