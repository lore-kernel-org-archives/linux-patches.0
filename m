Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0887DA78;
	Thu, 15 Aug 2024 13:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728662; cv=none; b=bdZcS8GwN9yuDlrUURUdfEhXtMNfNgRrsZ9ippH23Bw0Co2D1/9YOe86TOhB2M8SvMOuJvhvaf2J92E1S4tjT4UEXpCQoIhjT6iazHRBTvUZ49WCAIrWhhm36+Kei/PdS6WTks3w4mjVqtEKY8QyHcW7n5dmRqJ7ZNQsBC/ytmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728662; c=relaxed/simple;
	bh=nfqGgK+sQijgK5ZPjKB+e7yNzbMGgXLEUlGLLJKvojQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPiLiqkYXGhw33j4jGUkPOD2gbcKA2IDCnCMk3uMy1cPha5Sxca751sc3rgcjtcJE+vI0/GLpwEdmtLj90D/KVSNfwQ0j/ucUI1ZglzsL/RSHoynhMCrAD5Efa47G9Rp+QVwpbXbasXyHKpmDkLRv3Rj3JxoqaqhVENPV2NzAxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0sshmbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0sshmbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D29C32786;
	Thu, 15 Aug 2024 13:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728662;
	bh=nfqGgK+sQijgK5ZPjKB+e7yNzbMGgXLEUlGLLJKvojQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0sshmbJIF2IxhA2301jMOFcf9g4ta7wH1mta97VGNuEVwTkSOdeJ2Pv1wNiZ4Srv
	 UYsoDnai5tYiOJhqn5zXmbQVg3AEautQhyeouwMiT48NdwVUSWdZ2dMZhkDKnafgsD
	 pMZqWBzwZWhHVexEmOEWG5oLA1jBCTDqZZDZKyms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 4.19 070/196] drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes
Date: Thu, 15 Aug 2024 15:23:07 +0200
Message-ID: <20240815131854.755561403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 2df7aac81070987b0f052985856aa325a38debf6 upstream.

In psb_intel_lvds_get_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Fixes: 89c78134cc54 ("gma500: Add Poulsbo support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709092011.3204970-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/psb_intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -519,6 +519,9 @@ static int psb_intel_lvds_get_modes(stru
 	if (mode_dev->panel_fixed_mode != NULL) {
 		struct drm_display_mode *mode =
 		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		if (!mode)
+			return 0;
+
 		drm_mode_probed_add(connector, mode);
 		return 1;
 	}


