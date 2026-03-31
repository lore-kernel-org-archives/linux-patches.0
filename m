Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC60426EA3;
	Tue, 31 Mar 2026 16:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975112; cv=none; b=NUmajCjr7C5JoOcRMkNN15ZRX90OeoPcuAsDMOl/qRb2ueWHZ5fab3yEo9KQAdPr8wJxdsZu01UGnT5BsN4bK64wOrOehKiOHewI0cTZ4TQBJceES6CWmkWsxD5Zt7ezbk3mp6jh2n3NdeDKuMfQrJmBrltmwTs1k1vp9QjSjA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975112; c=relaxed/simple;
	bh=3fexK56KeJJ89axbFp1l7z2V9QqyWyQcdk4ik1zKxWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwDiPRZWAK87vfCpKVcE/bSGpjlKQADK1QIF7ndeOViR/BTIUrajCARMWKkv+B7YYSOrMqSqcn1Gc7A0/MeuaJHDE95hH2AwihqUyVvcMwqvEQ44cp5vcJfqyrsroWQr+sjEn6mIWLDQsvzrlPWoCDxkR2m3vAR+GrkVY3syRI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09qhNNFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09qhNNFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7A0C19423;
	Tue, 31 Mar 2026 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975112;
	bh=3fexK56KeJJ89axbFp1l7z2V9QqyWyQcdk4ik1zKxWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09qhNNFsJukISfUbytsDciPfGZKH59pWfVgsuGWS5WEUzT/ZC8vZg0z8yDfVBxxQi
	 nfccurRpyRmMcnfagtZ/x/BSI0VJ9nXpgoxzzAm/YMOoNSNT1U584jlnzqgEElV2HP
	 typbekmjbhrfbAeFj3esOGemwk2m1gQu471GfS+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 169/342] drm/i915/gmbus: fix spurious timeout on 512-byte burst reads
Date: Tue, 31 Mar 2026 18:20:02 +0200
Message-ID: <20260331161805.230431223@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit 08441f10f4dc09fdeb64529953ac308abc79dd38 ]

When reading exactly 512 bytes with burst read enabled, the
extra_byte_added path breaks out of the inner do-while without
decrementing len. The outer while(len) then re-enters and gmbus_wait()
times out since all data has been delivered. Decrement len before the
break so the outer loop terminates correctly.

Fixes: d5dc0f43f268 ("drm/i915/gmbus: Enable burst read")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patch.msgid.link/20260316231920.135438-2-samasth.norway.ananda@oracle.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 4ab0f09ee73fc853d00466682635f67c531f909c)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_gmbus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_gmbus.c b/drivers/gpu/drm/i915/display/intel_gmbus.c
index 795012d7c24c2..5a941bea81cad 100644
--- a/drivers/gpu/drm/i915/display/intel_gmbus.c
+++ b/drivers/gpu/drm/i915/display/intel_gmbus.c
@@ -498,8 +498,10 @@ gmbus_xfer_read_chunk(struct intel_display *display,
 
 		val = intel_de_read_fw(display, GMBUS3(display));
 		do {
-			if (extra_byte_added && len == 1)
+			if (extra_byte_added && len == 1) {
+				len--;
 				break;
+			}
 
 			*buf++ = val & 0xff;
 			val >>= 8;
-- 
2.53.0



