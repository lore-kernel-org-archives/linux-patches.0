Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F701F709A;
	Tue, 17 Dec 2024 17:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456270; cv=none; b=gemKoGAKf9ztCPJdqGxCgLMrfullEUBfLuFBcutKiww3i6JX1q74qgLGGMcDJTvnmI9eseo7a5/IAdQXrE081AQ3zuO7z91KTiaoYLFb9lDgJ+avatTwvgneAxOm/bt0WUPksnDh2RMDplDHjOvs2Kr4p+QpBoGDU1KOAzt4NxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456270; c=relaxed/simple;
	bh=ncnpheOOzDbo9L2kqe2bArMRLUbvVyzyDTktJe81e2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHk0Uni2kbB/cBtfTJsTS+zdf9rf1UNnpdcj0nXUSjCoSzJF7tWN6weWVsNiJx9RYVeYSdkT7X/h8RBV4s39aJy0KPpmYGtapEm+B1uddfHTJVIGOyS3eEsLJG6l3CO/81AO+OXpgfcqIXLGnQ7TnLMPCCEYF1ztRpRs2ZJ6Hs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsQFHFua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsQFHFua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2059EC4CED3;
	Tue, 17 Dec 2024 17:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456270;
	bh=ncnpheOOzDbo9L2kqe2bArMRLUbvVyzyDTktJe81e2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsQFHFua1/NT825eciF3R+ldClwV7hugXjqaKcqwg0tjDq1MtMKmqixQpoI8PoA8V
	 SbnDwsHuihVjSzCPKpyDwRBi+KDrWtBKAvZ3cNOjomfs8jNY3L2055mvGtlSArbR0s
	 VMezHphbvmkciMyGyH5e88SluGFcpwlNH4wR4mjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.6 103/109] objtool/x86: allow syscall instruction
Date: Tue, 17 Dec 2024 18:08:27 +0100
Message-ID: <20241217170537.708375898@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit dda014ba59331dee4f3b773a020e109932f4bd24 upstream.

The syscall instruction is used in Xen PV mode for doing hypercalls.
Allow syscall to be used in the kernel in case it is tagged with an
unwind hint for objtool.

This is part of XSA-466 / CVE-2024-53241.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3719,9 +3719,12 @@ static int validate_branch(struct objtoo
 			break;
 
 		case INSN_CONTEXT_SWITCH:
-			if (func && (!next_insn || !next_insn->hint)) {
-				WARN_INSN(insn, "unsupported instruction in callable function");
-				return 1;
+			if (func) {
+				if (!next_insn || !next_insn->hint) {
+					WARN_INSN(insn, "unsupported instruction in callable function");
+					return 1;
+				}
+				break;
 			}
 			return 0;
 


