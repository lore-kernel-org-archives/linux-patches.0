Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B607E41167E;
	Tue, 21 Jul 2026 19:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660648; cv=none; b=fViJYuK3yw9g5JbzLMex605RQCe5cH5/31GmQhQxR0w1pXqKSuvQUbCAl7OdRPbf/7VtVxL1GbU67PrpTq+KBBBvGk2ApcQlbfRLujVtxevWfMqSKxoQKzDzs5oqlNYuHenCndqcP18zBb0pFj+wFxKfU/Govj1Ajudzf/YpXH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660648; c=relaxed/simple;
	bh=zQakYaxRDHiZRNjrlzD5eGMRYG42wdPtPiNfDFs8zls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIjGEp9zaaZz7cCvsySOSyINlFbFtLFNZuoNpM0HYBnci1PIJKs9FZwdqbZ2PwDOI27OWQSshpu3SQF/A5fwUYymIHkmZM+zCWolgxM697Sbwi/NjfzL984AKmmaFBev4r99eaUBnBRIMvF6EZb2++F702n5oUfsZyJkbLCCYjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFPBEMwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFPBEMwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2074B1F000E9;
	Tue, 21 Jul 2026 19:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660647;
	bh=CdI6Q/i3McqQ9BSK/r9dHoPaO2YVn41EBTS4Y0XJJEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFPBEMwkwt23Li8LFLyjBRk99ZjXT0yAHju98bO2kn963EzPAYWZLjHOgbR1U11Co
	 X6j1Al9pghm0FjXTDaJcp5QQ5tbv9HrIiv/DhAzzUjc2g3OFLGuW+LtU8ZAA6lmYA5
	 9UykgKD3cBAv0gNeEwvpBhRMk56QjaXm3q02qtds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1015/2077] perf symbols: Bounds-check descsz in sysfs__read_build_id() GNU fallback
Date: Tue, 21 Jul 2026 17:11:28 +0200
Message-ID: <20260721152616.759620652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1b4e9fbdeabc549965e70ac0cd8095d57ff6df06 ]

When sysfs__read_build_id() matches NT_GNU_BUILD_ID with the right
namesz but the name content is not "GNU", it falls back to reading
descsz bytes into the stack buffer bf[BUFSIZ]:

    } else if (read(fd, bf, descsz) != (ssize_t)descsz)

Unlike the else branch which validates namesz + descsz against
sizeof(bf), this path passes descsz directly to read() without any
bounds check.  A crafted sysfs file with a large n_descsz overflows
the 8192-byte stack buffer.

Add a descsz > sizeof(bf) check before the read, breaking out of
the loop on oversized values.

Fixes: e5a1845fc0aeca85 ("perf symbols: Split out util/symbol-elf.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index c415670453bed9..70f3b553baf082 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -960,8 +960,13 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 					err = 0;
 					break;
 				}
-			} else if (read(fd, bf, descsz) != (ssize_t)descsz)
-				break;
+			} else {
+				/* descsz from untrusted file — clamp to buffer */
+				if (descsz > sizeof(bf))
+					break;
+				if (read(fd, bf, descsz) != (ssize_t)descsz)
+					break;
+			}
 		} else {
 			size_t n;
 
-- 
2.53.0



