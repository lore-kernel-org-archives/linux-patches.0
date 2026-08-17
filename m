Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BF73DC857;
	Mon, 17 Aug 2026 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975654; cv=none; b=DEldnE3JzhDG0pR8lTIFb9gpva9kmxvZ64Ux8wbxSMUkMWpZtdvtz3c5rmgP3IFALTxNI1VouPWdBRzqav1L4AFv9m1SIs3VfOCKlbmkX/7VlYfqKyhaHfRIW5ahD01O+b68fLyeGz8YjkFMFW9L2KGGa+h0t3ZlDCJdZIYWPUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975654; c=relaxed/simple;
	bh=x45il6zdJoaya3MHjvbucfkG5sIz0TnLYPOOmcV/NCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks2H07h+xYmE+HG6+jBAaydFsSnzRCp/tg1uH5gOzFE1N5Vb1OYDjjeoDilZjVADL011G0duSIqopJXKRhZ0K5AEdQgTz5NMwVkbJ924fIE9hlJhboy75dd872mQPZtVRy+4130FOvkY9kzHd/EWudmEmdcQPbQB3lHfandOLU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ee3L9yIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ee3L9yIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15B41F000E9;
	Mon, 17 Aug 2026 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975653;
	bh=zzwPAEVRMnHc91kLrX9BQBP+yNDCf0Eal/PnREjL9SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ee3L9yImp23uTAk5HvVK4yiBZ660oj3Bp0kbmFdOazr4UZajaAVmeVsUGuFzQGZH1
	 01G8VECk+QU4T9p9hvI/rNog8k36xglXLhDH45riM9eBtBsmXUphS7V3s8W3L+uoO6
	 bWJ1VZcpk8LCkL2bdrurDrqpvLuGi7Rc6ohobRKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.10 101/389] drm/nouveau/acr: fix missing nvkm_done() in error path of nvkm_acr_oneinit()
Date: Mon, 17 Aug 2026 15:29:00 +0200
Message-ID: <20260817132543.077475460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit c3027973f692077a1b66a9fb26d6a7c46c0dc72c upstream.

In nvkm_acr_oneinit(), nvkm_kmap(acr->wpr) is invoked unconditionally
at line 309 to obtain a mapping reference. Additionally, when both
acr->wpr_fw and acr->wpr_comp are present, a second nvkm_kmap() is
called inside the conditional block. Both mappings are expected to be
released by nvkm_done(acr->wpr) at line 320 before the function returns
successfully.

However, when a mismatch is detected during the loop within the
conditional block, the function returns -EINVAL at line 318 without
calling nvkm_done(). This results in a leak of the kmap reference(s)
acquired earlier.

Fix the issue by invoking nvkm_done(acr->wpr) prior to the early return
to ensure proper release of the mapping references.

Fixes: 22dcda45a3d1 ("drm/nouveau/acr: implement new subdev to replace "secure boot"")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260606155606.77593-1-vulab@iscas.ac.cn
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c
@@ -314,6 +314,7 @@ nvkm_acr_oneinit(struct nvkm_subdev *sub
 					  i, us, fw);
 			}
 		}
+		nvkm_done(acr->wpr);
 		return -EINVAL;
 	}
 	nvkm_done(acr->wpr);


