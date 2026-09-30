Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC8051B166;
	Wed, 30 Sep 2026 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792949; cv=none; b=cTBn+1wz7+vtCdbWOtk8igUj0/5jKsOUvLew+stOU4THDSP52s6XfPsHTKUNfrczsxSNr+elalN/M648y0t6lu+B22FXBzGaYTCFktIDal64apjuDKooQjx6OIJI22RnHcUr3LJgVU7DYoaBw/bL45qVSeH8GeGBYl+NRsrRLTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792949; c=relaxed/simple;
	bh=zRf/CcHSKvEsZmh53OknwCfj/gVjLLU0wxCY7Uaijho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdsSOLSBfdSqg0rQLlWbkBm7yAfAiBgafzMEAAnPjgHacno2bh3Ll9pwU9ErfqIK4pp/iifBjTVNMx2gf0n7GESPgn2MU3gG2tkVhePRoRj2joStXMZp6QVdcjFAcVK/oKYPMwKc3ZGg/AyFY/hYXEyNs57JkBhWfs2G6ISsBEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reTO7qAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reTO7qAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574031F000FF;
	Wed, 30 Sep 2026 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792947;
	bh=gpqlOQSi49MUmNtEnG29ub+glsEKjBQhoLvbmiLzbbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reTO7qAua0axElq1nrVeTNBqga5JDMFXH4kmgbkZALde3NbBoY47fzpRBfmyB9yXm
	 /bdsbkLm4XwR6BFyYpwtGOlTIyE7CoUKPCINRi+8DFfqx2eQXy8jHbwbB2RtixZt3B
	 wCvuC+Si+DgpWMce69cG+h1PM9trK56KcNZ/KXd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Ranieri <giuseppe@ranieri.dev>,
	Tano Dzhinski <tano.dzhinski@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/395] drm/nouveau/disp: dont reject HDMI config on cards without SCDC
Date: Wed, 30 Sep 2026 17:25:37 +0200
Message-ID: <20260930152342.264391081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Ranieri <giuseppe@ranieri.dev>

[ Upstream commit 1717fcc5be575d4768279148ae9465a8b13d4339 ]

nv50_hdmi_enable() passes the sink's SCDC capability from its EDID
straight through to nvif_outp_hdmi(). On pre-Maxwell-2 cards there is no
hdmi->scdc callback, so nvkm_uoutp_mthd_hdmi() rejects the whole
configuration with -EINVAL, and nv50_hdmi_enable() returns before
hdmi->ctrl() runs and before the AVI and VSI infoframes are sent.

The result on such a card driving an SCDC-capable HDMI 2.0 sink is that
HDMI audio silently stops working. Video is unaffected, and nothing is
logged, which makes the failure hard to attribute.

SCDC is optional, and the hdmi->scdc() call further down is already
guarded against a missing callback. Requesting it on a card that cannot
do it need not invalidate the rest of the HDMI configuration, so drop
that term from the condition and let the existing guard skip SCDC alone.

Fixes: 6c6abab20b99 ("drm/nouveau/disp: add output hdmi config method")
Signed-off-by: Giuseppe Ranieri <giuseppe@ranieri.dev>
Co-Authored-By: Tano Dzhinski <tano.dzhinski@gmail.com>
Signed-off-by: Tano Dzhinski <tano.dzhinski@gmail.com>
Tested-by: Tano Dzhinski <tano.dzhinski@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260917215114.1136715-1-tano.dzhinski@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c
index 377d0e0cef848..9887b3898505b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c
@@ -253,8 +253,7 @@ nvkm_uoutp_mthd_hdmi(struct nvkm_outp *outp, void *argv, u32 argc)
 
 	if (!ior->func->hdmi ||
 	    args->v0.max_ac_packet > 0x1f ||
-	    args->v0.rekey > 0x7f ||
-	    (args->v0.scdc && !ior->func->hdmi->scdc))
+	    args->v0.rekey > 0x7f)
 		return -EINVAL;
 
 	if (!args->v0.enable) {
-- 
2.53.0



