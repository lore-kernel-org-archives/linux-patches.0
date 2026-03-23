Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A766F3AF66C;
	Mon, 23 Mar 2026 14:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274486; cv=none; b=NA0eiOjRNyUcG+EPj/XPyeg7vf8MrfdMQxA3MtWpqkvDhqfZJ7wUNI1A8q8C3xiK6UbiIpzrimIf8xDX+StnmdNtUCXLx2Y6Geag+031rvA1S1JcoZbc+cXo3rAmbnGgCm16OiH3q/ay+NPwYr4HTHQJwB/pgBw/bl72UPVnhl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274486; c=relaxed/simple;
	bh=zfzV2NLrMco4BVzVst6Q1fURZrSHZsezzccm/AS7aTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoYqO1bnJTJoFiCZLgioPM2T5JDYI2vsOIc23/bHks39RUjdtfe/SzBGN7idDA3ZLDh80ImElaIMOwBpf+JcIT66Gn5QWgyPHivEYYOhSorXbtAfzAJUnncOoFeiVDzQ9XYfo22GYH4oL/M7cjmvyS/BMRfMSzLHGWged8+h5Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExZsEH8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExZsEH8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED108C2BCB1;
	Mon, 23 Mar 2026 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274486;
	bh=zfzV2NLrMco4BVzVst6Q1fURZrSHZsezzccm/AS7aTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExZsEH8Z+tQsZsUx9wiU+GatXAAVTOpxPTR8rFVWbL6hHJxsQACdWSSWdLgZCNFMC
	 tSiOIqVPkdG2Ce4Xr2wHKtJAwi1lp174W8CehkjmX90zK/EULYZH3ONDymssh4O7P0
	 HyrczjBQOu0FBTMpvmRPsebe1ZAbjrnd+/pcl0aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 013/212] LoongArch: No need to flush icache if text copy failed
Date: Mon, 23 Mar 2026 14:43:54 +0100
Message-ID: <20260323134504.184215406@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit d3b8491961207ac967795c34375890407fd51a45 upstream.

If copy_to_kernel_nofault() failed, no need to flush icache and just
return immediately.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/inst.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/inst.c
+++ b/arch/loongarch/kernel/inst.c
@@ -246,13 +246,15 @@ static int text_copy_cb(void *data)
 
 	if (smp_processor_id() == copy->cpu) {
 		ret = copy_to_kernel_nofault(copy->dst, copy->src, copy->len);
-		if (ret)
+		if (ret) {
 			pr_err("%s: operation failed\n", __func__);
+			return ret;
+		}
 	}
 
 	flush_icache_range((unsigned long)copy->dst, (unsigned long)copy->dst + copy->len);
 
-	return ret;
+	return 0;
 }
 
 int larch_insn_text_copy(void *dst, void *src, size_t len)


