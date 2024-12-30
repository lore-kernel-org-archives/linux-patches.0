Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABBD15E8B;
	Mon, 30 Dec 2024 15:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573973; cv=none; b=ABKjQ6eaENCrw1A4RFaJJmBR8V6JCxSrD5SuzMiRdbmenAJspIKdn1qiCEJT1U2x8LqA/Ba3gW86E4u04qmY1xTuTx9PvraI+2kbdvVZRjVniWIm2xpemnXMP3Bjv/TQXuduc4ELQl6tgJv5k+xEso1pQlwTY3NnfWVQ97/caCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573973; c=relaxed/simple;
	bh=nFUlIluR10HKmaGxxUYOI7+UUTb/klX7ymoxPP6kPd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FA0VkNtVc2nIWw97QLNmnvWblb2EDuMuRFSg8sRnvugMJdFPNL3yfAAK+PL12tO+2pf5o0Pg5pmEBLBbPHAGw97dJbhjb1+A1WnfLZqcrP/xSpc44a7oNX205QMSTQCWitwMz3R7wSbB3NLbJ4dicgqlh7qy+fbxT+WVh+M6aco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZP8wWtXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZP8wWtXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6429DC4CED0;
	Mon, 30 Dec 2024 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573972;
	bh=nFUlIluR10HKmaGxxUYOI7+UUTb/klX7ymoxPP6kPd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZP8wWtXF7e899W6l1mi7J92Q6bn77aFHTcwn8qqA344TRIv0t8NZ+LG14+32CWMlB
	 34XZgPjgbnnaaehuXf0ntyMonqfK68tDijik+XYY3NaDddNCDXlW2uBac5TCBhGj/q
	 yiphzhYJ7zcs+uvOBbz3JqPSy/IqrFjDDH2DLfTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 64/86] x86/cpu/vfm: Add/initialize x86_vfm field to struct cpuinfo_x86
Date: Mon, 30 Dec 2024 16:43:12 +0100
Message-ID: <20241230154214.148959706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit a9d0adce69075192961f3be466c4810a21b7bc9e ]

Refactor struct cpuinfo_x86 so that the vendor, family, and model
fields are overlaid in a union with a 32-bit field that combines
all three (together with a one byte reserved field in the upper
byte).

This will make it easy, cheap, and reliable to check all three
values at once.

See

  https://lore.kernel.org/r/Zgr6kT8oULbnmEXx@agluck-desk3

for why the ordering is (low-to-high bits):

  (vendor, family, model)

  [ bp: Move comments over the line, add the backstory about the
    particular order of the fields. ]

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240416211941.9369-2-tony.luck@intel.com
Stable-dep-of: c9a4b55431e5 ("x86/cpu: Add Lunar Lake to list of CPUs with a broken MONITOR implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6e775303d687..428348e7f06c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -81,9 +81,23 @@ extern u16 __read_mostly tlb_lld_1g[NR_INFO];
  */
 
 struct cpuinfo_x86 {
-	__u8			x86;		/* CPU family */
-	__u8			x86_vendor;	/* CPU vendor */
-	__u8			x86_model;
+	union {
+		/*
+		 * The particular ordering (low-to-high) of (vendor,
+		 * family, model) is done in case range of models, like
+		 * it is usually done on AMD, need to be compared.
+		 */
+		struct {
+			__u8	x86_model;
+			/* CPU family */
+			__u8	x86;
+			/* CPU vendor */
+			__u8	x86_vendor;
+			__u8	x86_reserved;
+		};
+		/* combined vendor, family, model */
+		__u32		x86_vfm;
+	};
 	__u8			x86_stepping;
 #ifdef CONFIG_X86_64
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
-- 
2.39.5



