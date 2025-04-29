Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FF8224AE6;
	Tue, 29 Apr 2025 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947404; cv=none; b=cm0ZjOlCtpMIOlMLuPAWjBAcyqucsQTckqV0hC/ZCxOUtEX9v9TnJyy0fkzT1xXfbUxivwpTr/FK/SrToAjLQ3/p0keGSrArSOvt/IEyP6w8UAc9NSnCQDOjCO3e306oLzmFDNwmkUCZnO0twmmL3aPXIurp3YFx2dm2A4VDvBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947404; c=relaxed/simple;
	bh=zD5MpW9WDe9jwuEf5perCXueZIzBuoqYjNuohgnQA7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRa2BoWF5PRgRex3omlEiaZ9JlJETeb/UvoUx0L//3CxYm1xlZnJPtX09fq0ffGsBfUU5njkYS22L1VZ9bUT02qc/Li0WkSM/LHvMC/hXYRbO6l2wtzNwhudoz2U33G8/0G/gl5U160ZA141iG27cIf72Y1SgRM5K03QIQJeaWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1RgrKfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1RgrKfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D6DC4CEE3;
	Tue, 29 Apr 2025 17:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947403;
	bh=zD5MpW9WDe9jwuEf5perCXueZIzBuoqYjNuohgnQA7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1RgrKfN3O11ZN1hcy34X+KaE0i2i/9Luu3HjLVMQ/DMmP6NUzZF3jV2XGueofZ1F
	 42EMvH1YLueH729i6HIlwy8i+TjZxC32cm1H5g+gflJAAQIsQAXT/mpREaP+fvJHIO
	 ZThfzBSOY56ZMVFQge7Ex9O3rBC7Pq2eb8zUqMyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/286] objtool: Stop UNRET validation on UD2
Date: Tue, 29 Apr 2025 18:42:54 +0200
Message-ID: <20250429161119.026645853@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 9f9cc012c2cbac4833746a0182e06a8eec940d19 ]

In preparation for simplifying INSN_SYSCALL, make validate_unret()
terminate control flow on UD2 just like validate_branch() already does.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/ce841269e7e28c8b7f32064464a9821034d724ff.1744095216.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index bcc9948645a00..20ccdd60353be 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3249,6 +3249,9 @@ static int validate_entry(struct objtool_file *file, struct instruction *insn)
 			break;
 		}
 
+		if (insn->dead_end)
+			return 0;
+
 		if (!next) {
 			WARN_FUNC("teh end!", insn->sec, insn->offset);
 			return -1;
-- 
2.39.5



