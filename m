Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A54D347BC6;
	Tue, 21 Jul 2026 22:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674356; cv=none; b=JS0UFzbvkjwSullVHe23HRl575HtAVJGWvFBAzxA0UzaNwukxbOwGGKKE3zm5QgSi0FAQDtBrqh4yrby3ir7EL/eBqApmg0thfvmpz5dWrRuuy47eXF5mfC5inL9dgG3/IHOHn5RTeyCO8LxCkW9J08gX4mgJp/Eny1Pd5g01fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674356; c=relaxed/simple;
	bh=NCumlU8dAZ7mWi2/gwmn/puOlflkSZrjGm2Wj1/KCOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qryAhHFQ0myXNHinzo9CI5weIySwqw4tjfhV+t1+S1Hib3XdYhkzac3p8/x5lWt+Rg+D/8Jb4wGwPS2j32tcFdgavVL51MS6PR95+R/QPw47LI7AjPkDFNdmDMPHQoxXWr9VhQ68fEoEAA4liEdrTsXdKlEU/Zt5AkI0mOGxLaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjT69ozC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjT69ozC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15641F000E9;
	Tue, 21 Jul 2026 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674355;
	bh=VmqqoxrhWKNxy9NLYvrX+EGxa/vWIi14L4++jRjGPwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjT69ozCCTNCxwNMCNAzC8o9r7t4XIJv478mdAl980adUFStPpQW92yLSYxJ04ZWE
	 vJjihmvhR9QD45ycGsDyJ5db7tapSCt8iOPzu5LqpgF3G7S4O8bp/JO8YokeZAYBEy
	 0395PIUf6b4+j74s0YPKVmweK7GxGEW+XKOHqBrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 511/699] dm-stats: fix dm_jiffies_to_msec64
Date: Tue, 21 Jul 2026 17:24:30 +0200
Message-ID: <20260721152407.222648780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 386df1a57b631c456d14f857cb0c0c2e11c16bef upstream.

There were wrong calculations in dm_jiffies_to_msec64 that produced
incorrect output when HZ was different from 1000. This commit fixes them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -799,10 +799,10 @@ static unsigned long long dm_jiffies_to_
 		result = jiffies_to_msecs(j & 0x3fffff);
 	if (j >= 1 << 22) {
 		mult = jiffies_to_msecs(1 << 22);
-		result += (unsigned long long)mult * (unsigned long long)jiffies_to_msecs((j >> 22) & 0x3fffff);
+		result += (unsigned long long)mult * ((j >> 22) & 0x3fffff);
 	}
 	if (j >= 1ULL << 44)
-		result += (unsigned long long)mult * (unsigned long long)mult * (unsigned long long)jiffies_to_msecs(j >> 44);
+		result += (unsigned long long)mult * (unsigned long long)(1 << 22) * (j >> 44);
 
 	return result;
 }


