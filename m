Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774954;
	b=oyRpyswiB2dSLDKSIN0r1mJ5OEMtp4W3O6gfdm+bLHRExOavKdAemZ11UOPUgkOQked2
	 tJH4b+QSoiizczhNZ8JLWCvx5vhYBYGMW6ohvV+Ss2AcdctZo5VszGu5PtNPjKGqhXQzD
	 ukfwrsg5v2R865y+19NROclF6jbW8kAHODwGtdunHptILduF4Bw2igWH0VnhV32eghO44
	 N5v0ZHF8Z/zulyilkmv6bTxTbfObd887rgatZfF6pMwvbgMUcIhsB/23OrRI/BWsEKAMc
	 0+IAGNJqHbV1iXYQahnHiXf6b/4LWye/+q73z2gqL1/s3sp8o1q4Mqg1rWmKni0x6qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vnEOpi6uOfsgcVqg5GRSI705dK17DOgWVIBZkSbd/OY=;
	b=ALcLYbj5llfqW2sgpN534fHvwJG2whhj8cJ8i2YWUgVlfCwOh4vLgUZzA+KEU4V/DGiv
	 xsSJfA1COYMZEKAxjivESxf09vq3iltLO7/dIR7xI4DgQtd6PeXLojGzKP8PhKBRLIyDa
	 mAi60kDlLA3coYtVWYF6XDgdOzFtRL7Gv5F9vgReHj0N3k7UaiQJov4BQocq6i7N7IMod
	 CMidpF/1sGpolC7FCol9A7petY0diX18tQJ4lJior2shsHHtB91tlH3PPvjMCtzKrXJnu
	 UeUwa5I0seQPJlR/7TSUGRB8KS4e9/xzec5vdFTDV1CgtODYDhoPT4CnPwaJO0MNldg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E7f0a/fj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D19606A31A;
	Fri, 23 Oct 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7f0a/fj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAD21F01825;
	Fri, 23 Oct 2026 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774954;
	bh=vnEOpi6uOfsgcVqg5GRSI705dK17DOgWVIBZkSbd/OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7f0a/fj+nYoLUOaq9U63Il5EWAQWE3OZ5ZOvOQAdjeddYfzGHe/4xitySS+kSOPf
	 7ibTkdHu5FlwRpX0Ruj9uXWZ0h1lCCwE75k7sgkuoBtocVhyWQ32EnoWCbFteXU/cz
	 RL0uXbOarHSb1+FpPHnfnK8IeSokj1jia2Im7sjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 175/242] tracing: Fix ignored return value of resize_buffer_duplicate_size()
Date: Fri, 23 Oct 2026 18:40:17 +0200
Message-ID: <20261023163717.923178792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

commit 3110d09bb98e3ac66482a7b257548a1683ec6c1a upstream.

When tr->allocated_snapshot is true, resize_buffer_duplicate_size() is
called to update the snapshot buffer size. However, its return value was
not checked. In case of a failed resize this could lead next snapshot
being incomplete.

Add resize_buffer_duplicate_size() result check and return error if
resize fails.

Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928152634.4354-1-d.kandybka@gmail.com
Fixes: 180e4e390978 ("tracing: Add snapshot refcount")
Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_snapshot.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_snapshot.c
+++ b/kernel/trace/trace_snapshot.c
@@ -675,9 +675,12 @@ tracing_snapshot_write(struct file *filp
 		if (iter->cpu_file != RING_BUFFER_ALL_CPUS)
 			return -EINVAL;
 #endif
-		if (tr->allocated_snapshot)
+		if (tr->allocated_snapshot) {
 			ret = resize_buffer_duplicate_size(&tr->snapshot_buffer,
 					&tr->array_buffer, iter->cpu_file);
+			if (ret < 0)
+				return ret;
+		}
 
 		ret = tracing_arm_snapshot_locked(tr);
 		if (ret)


