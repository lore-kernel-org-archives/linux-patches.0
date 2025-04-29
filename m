Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE67242D6A;
	Tue, 29 Apr 2025 17:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947883; cv=none; b=aBSEu1Od+yRuzgaiBEO+V4PfQTfhTz1z0SSuCus3faFA6kl3xQtQeQDundZvcH+DHCBMQKK22+D0HpYobcGTgJjgPWqEUfSxqooiJS6sdweIBLs95o6y2YmmyIcx8UpjS8YthCTQjtCOrsVrtNnroHhrGQaf75kU+BfSK3sqK40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947883; c=relaxed/simple;
	bh=cirfQG/aHiYH61f5Vs2vXxn0Qe4F7WVHA9Guwbu303U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZRFDfkYw9YvwHTvuXz1tqErHp31t+EbTlXAdche2aZHrWvPj3zNtPgKqnGB8fiL1W30LyRRIEc/K+RACbl4dlKpSW5H19Swd2XmkS1dE4OJ6mMJ9XO31/pAvP2jtmCh2VeE0EaDzXUI1rvI04PoPv43hehYAXyUw+d/2juotDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c62ucrOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c62ucrOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3066EC4CEE3;
	Tue, 29 Apr 2025 17:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947883;
	bh=cirfQG/aHiYH61f5Vs2vXxn0Qe4F7WVHA9Guwbu303U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c62ucrOl981Myx8D6u2y0P2l0dURDHk7oJP6r5vJ8ByQ0LAbnRCIzuq8sTId4bDAh
	 hOYQliXjpFee/WSWwpYpKAiwm+sf/vRXBX//+s69cr2fhQBND/E7uRM3vO67qoxCBq
	 /DRWIMAl3WLp4UsRIW+gmcreLuWSxC7RKxCTdYR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 6.12 105/280] x86/insn: Fix CTEST instruction decoding
Date: Tue, 29 Apr 2025 18:40:46 +0200
Message-ID: <20250429161119.405299971@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit 85fd85bc025a525354acb2241beb3c5387c551ec upstream.

insn_decoder_test found a problem with decoding APX CTEST instructions:

	Found an x86 instruction decoder bug, please report this.
	ffffffff810021df	62 54 94 05 85 ff    	ctestneq
	objdump says 6 bytes, but insn_get_length() says 5

It happens because x86-opcode-map.txt doesn't specify arguments for the
instruction and the decoder doesn't expect to see ModRM byte.

Fixes: 690ca3a3067f ("x86/insn: Add support for APX EVEX instructions to the opcode map")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org # v6.10+
Link: https://lore.kernel.org/r/20250423065815.2003231-1-kirill.shutemov@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/x86-opcode-map.txt       |    4 ++--
 tools/arch/x86/lib/x86-opcode-map.txt |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -996,8 +996,8 @@ AVXcode: 4
 83: Grp1 Ev,Ib (1A),(es)
 # CTESTSCC instructions are: CTESTB, CTESTBE, CTESTF, CTESTL, CTESTLE, CTESTNB, CTESTNBE, CTESTNL,
 #			     CTESTNLE, CTESTNO, CTESTNS, CTESTNZ, CTESTO, CTESTS, CTESTT, CTESTZ
-84: CTESTSCC (ev)
-85: CTESTSCC (es) | CTESTSCC (66),(es)
+84: CTESTSCC Eb,Gb (ev)
+85: CTESTSCC Ev,Gv (es) | CTESTSCC Ev,Gv (66),(es)
 88: POPCNT Gv,Ev (es) | POPCNT Gv,Ev (66),(es)
 8f: POP2 Bq,Rq (000),(11B),(ev)
 a5: SHLD Ev,Gv,CL (es) | SHLD Ev,Gv,CL (66),(es)
--- a/tools/arch/x86/lib/x86-opcode-map.txt
+++ b/tools/arch/x86/lib/x86-opcode-map.txt
@@ -996,8 +996,8 @@ AVXcode: 4
 83: Grp1 Ev,Ib (1A),(es)
 # CTESTSCC instructions are: CTESTB, CTESTBE, CTESTF, CTESTL, CTESTLE, CTESTNB, CTESTNBE, CTESTNL,
 #			     CTESTNLE, CTESTNO, CTESTNS, CTESTNZ, CTESTO, CTESTS, CTESTT, CTESTZ
-84: CTESTSCC (ev)
-85: CTESTSCC (es) | CTESTSCC (66),(es)
+84: CTESTSCC Eb,Gb (ev)
+85: CTESTSCC Ev,Gv (es) | CTESTSCC Ev,Gv (66),(es)
 88: POPCNT Gv,Ev (es) | POPCNT Gv,Ev (66),(es)
 8f: POP2 Bq,Rq (000),(11B),(ev)
 a5: SHLD Ev,Gv,CL (es) | SHLD Ev,Gv,CL (66),(es)


