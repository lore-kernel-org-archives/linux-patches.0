Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916701F9A92;
	Tue, 17 Dec 2024 17:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456803; cv=none; b=BwbY36g4lbMVMpLC7yqKlNPA/eQ3JKbsH1k39wrsokvcroc6/Xy+jsI8j4tbZ4b4Lm1+1hDt0r/tY/OlVyKLydE2X9ol8wgBECm0FmB2Oy2NRYWaiF1pzmtjV7MX6f2AHla6894QmtAKHaWvTYgFkFi8quTmi4bUpfF8OVuYzhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456803; c=relaxed/simple;
	bh=a/1EuTflVM4Hi6SzqwafTsg3iBYWwiaSgM4o5SK2aak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEVeoIOidcRNwH+H80pBAaYX/iYSy+75csgUB/ddyRwQRE1HD8XdA5MVuxI3khgNZggUmXzpO0n4MiWJkyhsULT6AxTKGTbkoyzFdeC4E/ZY+ulMkDmcYsCOglRnKPClFhlUhH8OxYId1ds4494uOm3RVs933B+h25BOotsL4f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyDaNr4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyDaNr4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AAFC4CED3;
	Tue, 17 Dec 2024 17:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456803;
	bh=a/1EuTflVM4Hi6SzqwafTsg3iBYWwiaSgM4o5SK2aak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyDaNr4Ad0A+coYhXuOoacVyomCobjUXB5J6TiuU3AwCxwcycfI1QvsfvkAR5j59t
	 mdRwIzVEVD//LHakkNfWM1wX6HL6A4iBRQVMh3oql9aSi0/Y0oFhcUq3MJ8i/gpYHN
	 GkOs0JoXpDTPD9wHwiWIcSnGTzC/J1lcDayH/x7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.12 167/172] objtool/x86: allow syscall instruction
Date: Tue, 17 Dec 2024 18:08:43 +0100
Message-ID: <20241217170553.258269907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3820,9 +3820,12 @@ static int validate_branch(struct objtoo
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
 


