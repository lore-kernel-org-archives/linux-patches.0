Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F7A19B3DD;
	Tue, 16 Jul 2024 15:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144669; cv=none; b=ijWycfWfPhIK9kPTSeGlZgYYduRo1d3vS/YeHQMZ2mJdmSat1XJM94uHVKYpGNVZhlpge+tlKyYIxR8qvw58rjDrYjI4S6iWASjTap04NC3Ypj+pKoj1MYAmhtEKvroqKsYF9JeglNtLbMyIpcDOcvF/4nusVBkSq034nbmboGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144669; c=relaxed/simple;
	bh=RIdiEtPqB0lr2Wbd4MG8bXWQfdzF8FPsPvBEmUnCsnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV40TTGkA2VFOvZMMgD0ptqDKU+/5Z8AuF2nwq0njV5HDQfrIAoTCeNyOyl1Z55ZiCrBMW/c7T04mrFvtNU+Eicgnwhb69t8MfVjRJ5nDvKGJSXhcGzBCVaj2jd8+MJl25ropWiSToBviWP2L1sZWX/dYjkUEfhKN+oHnFwqQT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykv1GTNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykv1GTNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A01C116B1;
	Tue, 16 Jul 2024 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144669;
	bh=RIdiEtPqB0lr2Wbd4MG8bXWQfdzF8FPsPvBEmUnCsnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykv1GTNQ4mHKntHRFvURswTPKEf9E+zSQb+5PkYkVRCYuYXqyeeuMXvFMHMXiGSA/
	 qQbcSnUfxalDE9OSHEE+zkdzReHMfJXOEB6wKiWjGrFDWFpV4LyVeBoYqth5kUzPPK
	 sDtUoSW9RIbhN8QBRFEzjCug9nf/30Y7yG2x/YGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Michal Hocko <mhocko@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Mateusz Guzik <mjguzik@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Tycho Andersen <tandersen@netflix.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 036/108] mm: optimize the redundant loop of mm_update_owner_next()
Date: Tue, 16 Jul 2024 17:30:51 +0200
Message-ID: <20240716152747.384147491@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinliang Zheng <alexjlzheng@tencent.com>

commit cf3f9a593dab87a032d2b6a6fb205e7f3de4f0a1 upstream.

When mm_update_owner_next() is racing with swapoff (try_to_unuse()) or
/proc or ptrace or page migration (get_task_mm()), it is impossible to
find an appropriate task_struct in the loop whose mm_struct is the same as
the target mm_struct.

If the above race condition is combined with the stress-ng-zombie and
stress-ng-dup tests, such a long loop can easily cause a Hard Lockup in
write_lock_irq() for tasklist_lock.

Recognize this situation in advance and exit early.

Link: https://lkml.kernel.org/r/20240620122123.3877432-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tandersen@netflix.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -432,6 +432,8 @@ retry:
 	 * Search through everything else, we should not get here often.
 	 */
 	for_each_process(g) {
+		if (atomic_read(&mm->mm_users) <= 1)
+			break;
 		if (g->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(g, c) {


