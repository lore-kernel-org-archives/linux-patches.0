Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C381B35C6B8;
	Tue, 21 Jul 2026 21:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669480; cv=none; b=G+wxap3cL4p3gxl828vj4HgsaWwejcg7y20NcoSeda1jNpNIY3llb91d8D3Xa+i8Xi0jTaY3e5x6RZdW3ZZ1vz6BRu9zYpKqu5LhK3D9tGAPFoGUuxz+6F6lmfr4Hw+9isENCWCwA/Uw7sa/88SMwqS++jFhhJ5sQe6kD8iPbwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669480; c=relaxed/simple;
	bh=5S4vzVd8SqgIAxpr45ioy13lIzshuoDrtUcup3cXy4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GznWjWdSAHZUF+rdgW4csefRywk4k+qvuVs7vLvx6OExGO99MiaxyLPjIFo7wUmSmlsbnryPFpGSU3Skwf3zAJCQkMv/sxF98mYtYLGDjoiSdfGAKgJnHtuU0r6AgzDuGylMqIDUEf0NqaNlTALFH+1a1RlLDfrReQfmfSgrRPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVLFE5pr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVLFE5pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB4D1F000E9;
	Tue, 21 Jul 2026 21:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669475;
	bh=oKSKY2rF7aODx936aqPGrDSN5B7RhrAgZodOOwIXk+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVLFE5proeRGsSO3PPeRH5tmMlJew2cH92xoJ9X1BqiUpuoARd1tE44lPtCD2KeEH
	 4kTNn0kKAKC1unBpB1zHlHaKzJlWV85Rgbm4Z5ZKXq0jZzBypi1sfpto5iM+bQ/bOU
	 C3wXgojAnCA5fU3R1TIBS3TnSUSnsBcek/FzY8wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0562/1067] perf symbols: Break infinite loop on zero-filled notes in sysfs__read_build_id()
Date: Tue, 21 Jul 2026 17:19:23 +0200
Message-ID: <20260721152437.176904489@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 063c647b24f640657d6d9e2e90d620ea3ee19ae6 ]

sysfs__read_build_id() iterates ELF note headers from sysfs files in a
while(1) loop.  If the file contains a zero-filled note header (both
n_namesz and n_descsz are 0), the code computes n = namesz + descsz = 0
and calls read(fd, bf, 0).  read() with count 0 returns 0, which
matches the expected (ssize_t)n value, so the error check passes and
the loop repeats — reading the same zero bytes and spinning forever.

This can happen with corrupted or zero-padded sysfs pseudo-files.

Add a check for n == 0 before the read, since no valid ELF note has
both name and description of zero length.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: f1617b40596cb341 ("perf symbols: Record the build_ids of kernel modules too")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 0b8956740fd8ac..7e1b62388f0b72 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -723,6 +723,9 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 			} else {
 				n = namesz + descsz;
 			}
+			/* no valid note has both namesz and descsz zero */
+			if (n == 0)
+				break;
 			if (read(fd, bf, n) != (ssize_t)n)
 				break;
 		}
-- 
2.53.0



