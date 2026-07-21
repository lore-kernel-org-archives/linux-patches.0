Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B40444AB60;
	Tue, 21 Jul 2026 22:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673910; cv=none; b=B8PNZOcBtF5l0KeTy1rTd1Xq8nJD2je84i8mweR43MQXuMwKUUb5BopV0eluL4EwrDka/ZcCyS8he6zMe3zTy+NA/wZhhInfgNoR8A10V6dLFGD6JSGZlXDwKrz3T+eElXqQvBMCRnz+ftxnTPaxOnnRu0uxx7Lgmx7Wx0Y9xh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673910; c=relaxed/simple;
	bh=6YQ93S5lOQ0SSbG8Msrr55tVPP/HjXQhxRXemRnnI5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HKprSImbnjMfTQNtHahHZA3DG3Ndrx/AyBXrtEsdtjzWE+mWL16CyzsSL+O2V31ij/XXjxC1zuc0jOTZSs8BOOPn2twdLjYi3ax7pq6mQJJpRRUEN3vtbYn2tbmwjbhdOmmT/RPoGXGU7fXDzE7tg07iAQ8QGuk54FpJjmO/+fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTW/0rPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTW/0rPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15CF1F000E9;
	Tue, 21 Jul 2026 22:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673909;
	bh=Ua8cRd0/ja4NaTIPDZ8VlH1hkV5noMTalwT/Exz+VyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTW/0rPgehuxbqM8MgFJeJtuCgPsdK4j/GzqqMyP42prdTRttP1EEe3uPUwLsaHDs
	 PTihMn6AQ2/bpGRV00OLtfBLKY30wFIVBkPC2p4wCAVg12KKM9QbuaZFteEnpC6CLP
	 F0HfmTVMPGe7xn9XqEXhfsjikrTU1/N5oqneznSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/699] perf symbols: Fix signed overflow in sysfs__read_build_id() size check
Date: Tue, 21 Jul 2026 17:21:13 +0200
Message-ID: <20260721152402.777010045@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 6eaa8ee3e2abe5112e80e94c27196bb175689469 ]

sysfs__read_build_id() reads ELF note headers from sysfs files.  The
note's namesz and descsz fields are used to compute the skip size:

    int n = namesz + descsz;
    if (n > (int)sizeof(bf))

Both namesz and descsz are size_t from NOTE_ALIGN() of 32-bit note
header fields.  Their sum can exceed INT_MAX, overflowing the signed
int n to a negative value.  The check n > sizeof(bf) then evaluates
false (negative < positive in signed comparison), and read(fd, bf, n)
reinterprets the negative n as a huge size_t count — the kernel writes
up to MAX_RW_COUNT bytes into the 8192-byte stack buffer.

In practice the overflow is bounded by the sysfs file's actual size,
so a real sysfs notes file won't trigger it organically.  But crafted
input (e.g. via a mounted debugfs/sysfs image) could.

Fix by validating namesz and descsz individually against the buffer
size before summing, and change n to size_t to avoid the signed
overflow entirely.

Fixes: f1617b40596cb341 ("perf symbols: Record the build_ids of kernel modules too")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index b171d134ce87aa..907796a4699282 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -656,14 +656,17 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 			} else if (read(fd, bf, descsz) != (ssize_t)descsz)
 				break;
 		} else {
-			int n = namesz + descsz;
+			size_t n;
 
-			if (n > (int)sizeof(bf)) {
+			/* int sum of namesz+descsz can overflow negative, bypassing size check */
+			if (namesz > sizeof(bf) || descsz > sizeof(bf) - namesz) {
 				n = sizeof(bf);
 				pr_debug("%s: truncating reading of build id in sysfs file %s: n_namesz=%u, n_descsz=%u.\n",
 					 __func__, filename, nhdr.n_namesz, nhdr.n_descsz);
+			} else {
+				n = namesz + descsz;
 			}
-			if (read(fd, bf, n) != n)
+			if (read(fd, bf, n) != (ssize_t)n)
 				break;
 		}
 	}
-- 
2.53.0



