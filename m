Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452B11F8930;
	Tue, 17 Dec 2024 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455900; cv=none; b=ry7Tyz8tCkWVcVAu8BALw/nu2eq1KgJ1snDnT/+0ypxRs99pwkV9kyDGxn1N7XTiFQILzlF33qXKTUoms9rDjSjrDXHtSBLvyboUtQmW/3FYCzzzTvYrOtG/uHR7CIlgEFuVF6FESbKlUO3zOSxNn3Tz1ckKHHDamZwe3ixmqYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455900; c=relaxed/simple;
	bh=+P/SBR7gEWXDDWryX4bAhNoIYApsZp8IWtWUjoAvXRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHdJWu6X5ZKcepdREspxUlTJUpV+9FrZlZx+2SqbBmpMEpcKunBc3jZX4uRnZN3jMyYOU2LtPMtrVV5Cia/R/4S7jjJh8wecKCKQgIV/PKzFlrmAEC+mDHSygJFMSECli4mQd0SzMc3LeHDDC15etBhDKCdbhtUWbQIo0YdTc1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZdJL1+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZdJL1+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5452C4CED7;
	Tue, 17 Dec 2024 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455900;
	bh=+P/SBR7gEWXDDWryX4bAhNoIYApsZp8IWtWUjoAvXRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZdJL1+krrxtKmG77blu/Faa6Bd/BB+yjUbd5L9PycRQ1uh+Wcl5r77rbsf/VYo1U
	 4XqpUplgPd7jjpTkQo4IzxmVDwaC0NsHXqV7MO13f+F5P8Rwa9dS2JMIJzXZIqQHV9
	 FhOrtq3gFvu/I8aMCnMUeQfSPARRB0FbzYux26uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.1 70/76] objtool/x86: allow syscall instruction
Date: Tue, 17 Dec 2024 18:07:50 +0100
Message-ID: <20241217170529.399913551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 tools/objtool/check.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3521,10 +3521,13 @@ static int validate_branch(struct objtoo
 			break;
 
 		case INSN_CONTEXT_SWITCH:
-			if (func && (!next_insn || !next_insn->hint)) {
-				WARN_FUNC("unsupported instruction in callable function",
-					  sec, insn->offset);
-				return 1;
+			if (func) {
+				if (!next_insn || !next_insn->hint) {
+					WARN_FUNC("unsupported instruction in callable function",
+						  sec, insn->offset);
+					return 1;
+				}
+				break;
 			}
 			return 0;
 


