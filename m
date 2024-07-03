Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF5A173335;
	Wed,  3 Jul 2024 10:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003426; cv=none; b=IiQ5YwTs8Gha5qhmKygELjZvxxIHg3ceVUxKRQrQAf+xOaFQ77/hN5RcCkIJ5yFXXCN+R8Z9lm5h5Sb7rfJeNjKydl1U0GwTTsDIyq+8r2AHMS1n/oX3HSKp+6MbLrlEMZDhuGDnkYw8q+5A9oafuqEoVX5U08gQ+cwZ2jgbzfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003426; c=relaxed/simple;
	bh=/ZgZ23+gazvAgVM6GfrWauAWPuGTzO6E9ixpbR+6La4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ2NYHW54TWsv6zpX/utQX2jbBwJxpGeHPkSgEBotwT8nTx+YAQv4BcdtYm5KoZcic0HSPNkr1l3zmYHkuYHEete5a9ZnYv1fMbWMPwOxz9CxDQhTOpyEnOPE7t836fosxVQFdSST++30SU3Mvpa3pe5cHPL4sFqASS1/+Daf5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGCCNrER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGCCNrER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D11C32781;
	Wed,  3 Jul 2024 10:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003426;
	bh=/ZgZ23+gazvAgVM6GfrWauAWPuGTzO6E9ixpbR+6La4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGCCNrERPCqiHAX6KmwE1qKPq9OpE5qxHVYdUBzVCi8KvqG2ThYAL5FFlntm4fgoi
	 dVqHlXn6bqfL+xq9aIsmUCjekIl/ufF/F6SqvuV/jSqsoKnRKD1yqZcBZXYoM9DBc4
	 IXsAogNfsOfYO19mQg1QsaK4zg5mmHJ0E0r1HXX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 4.19 045/139] drm/exynos/vidi: fix memory leak in .get_modes()
Date: Wed,  3 Jul 2024 12:39:02 +0200
Message-ID: <20240703102832.139374767@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit 38e3825631b1f314b21e3ade00b5a4d737eb054e upstream.

The duplicated EDID is never freed. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_vidi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_vidi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_vidi.c
@@ -302,6 +302,7 @@ static int vidi_get_modes(struct drm_con
 	struct vidi_context *ctx = ctx_from_connector(connector);
 	struct edid *edid;
 	int edid_len;
+	int count;
 
 	/*
 	 * the edid data comes from user side and it would be set
@@ -321,7 +322,11 @@ static int vidi_get_modes(struct drm_con
 
 	drm_connector_update_edid_property(connector, edid);
 
-	return drm_add_edid_modes(connector, edid);
+	count = drm_add_edid_modes(connector, edid);
+
+	kfree(edid);
+
+	return count;
 }
 
 static const struct drm_connector_helper_funcs vidi_connector_helper_funcs = {


