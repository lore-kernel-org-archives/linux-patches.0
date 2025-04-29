Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1549382C60;
	Tue, 29 Apr 2025 17:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946097; cv=none; b=gsg0Yl68HAoLclgT6TjnWvEG/akxW+uhXOYHVpzXOLo0ZXJnwwlAI2n3cmYqppBJmOttr5F/Bw9KtJZ5etWfVyD729HiVW7u8qCW8yLNI9MXRr49IIontxoUcd9W20EKYaXnwfq5CDNwyFZDbsSmqHd/9eQ64JadPRpmdDQc2qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946097; c=relaxed/simple;
	bh=E0tkZNUpXAh/JLoatF2kAsvvwJ78uXtI3d0Py8Y9dfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6HLeFb3v4tAAcJxCCglPJiZA+IDLX/j7exycvzQVY2Fy6X9teFE9kcjmcIh6pFI82wZLW10dlNp9yMBgzHftdv8sFwK6NEJ8riy3zV8Un/LodXwVkgPyYyAJVer5LUpSjnV0eJwMiM3F7dplC752dMrYf43+RMgfiBHOnZhLUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTiUNUPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTiUNUPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FF0C4CEE3;
	Tue, 29 Apr 2025 17:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946097;
	bh=E0tkZNUpXAh/JLoatF2kAsvvwJ78uXtI3d0Py8Y9dfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTiUNUPJv3yOIr0xlTBNH4WdduUWZfSKc23PazN/69bhB9jSTUnGNrhg+o1o1y57t
	 Ow14jgfXa2cJN7Ue95jzU/4es89wGft6Jtp5uMDqc5IXqxDF4PSKkVpDqpJBGlZlIR
	 LkgZUMeBvXobOnqXEbavqwt4w/nvkYwbOwZ4bhsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 6.14 123/311] x86/insn: Fix CTEST instruction decoding
Date: Tue, 29 Apr 2025 18:39:20 +0200
Message-ID: <20250429161126.075231721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


