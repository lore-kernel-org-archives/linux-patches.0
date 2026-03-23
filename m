Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774713ACA68;
	Mon, 23 Mar 2026 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274038; cv=none; b=tfKNWL9o0EHeFLZGinInOHwa3Cha6pzcSAyBPSq7v/gkkg4lA0iw3Kx4H9w3Uj7IHkLsCtSvi/J5HAdNtA5eEgSPUf8ZJoRKEKQ4+KqmQao+IYc9esDE6yQN9bLvG0jjdqm+kr799Qpc0absnsdILQrI/w0I9nShG25yUD5gd4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274038; c=relaxed/simple;
	bh=KLqTtn41+D9erhxuieZbG8dP0SrvWDY6ccFdXjvOOL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxRLkXAlZ/edeJLJXg3A4pavTdUC3AaDooP97ZVsHHlDiSBa47nKq/cdwqNJ+Uy9UG0nkk8iRdb6EaIiIASNvL7LFqFT2o3t+LdqeCdniN9tQ8MLLifcPD2wVvj1++AOXguPmX8zNzF4G/JOM0yhO6i7Y/VV70b7tA9b48d+cfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jpt1ZojJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jpt1ZojJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02360C4CEF7;
	Mon, 23 Mar 2026 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274038;
	bh=KLqTtn41+D9erhxuieZbG8dP0SrvWDY6ccFdXjvOOL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jpt1ZojJflbCKKCiPtwtXTjT30nH1tM7CPzMlawiAX3S0JDS8gQ15mGiOaan5Ryxg
	 Yr0qZ6khmxwp420qmPgmJwvCFrAPSvGDa2Hx3szICei9cgdsOuzhYcMjEdvDZ8Lkbs
	 izGyteOqx/BpqD+Cti3qGdiGpV3gSFnnNfnEPNa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.19 090/220] drm/xe/oa: Allow reading after disabling OA stream
Date: Mon, 23 Mar 2026 14:44:27 +0100
Message-ID: <20260323134507.439481275@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

commit 9be6fd9fbd2032b683e51374497768af9aaa228a upstream.

Some OA data might be present in the OA buffer when OA stream is
disabled. Allow UMD's to retrieve this data, so that all data till the
point when OA stream is disabled can be retrieved.

v2: Update tail pointer after disable (Umesh)

Fixes: efb315d0a013 ("drm/xe/oa/uapi: Read file_operation")
Cc: stable@vger.kernel.org
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa<umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260313053630.3176100-1-ashutosh.dixit@intel.com
(cherry picked from commit 4ff57c5e8dbba23b5457be12f9709d5c016da16e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_oa.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -543,8 +543,7 @@ static ssize_t xe_oa_read(struct file *f
 	size_t offset = 0;
 	int ret;
 
-	/* Can't read from disabled streams */
-	if (!stream->enabled || !stream->sample)
+	if (!stream->sample)
 		return -EINVAL;
 
 	if (!(file->f_flags & O_NONBLOCK)) {
@@ -1460,6 +1459,10 @@ static void xe_oa_stream_disable(struct
 
 	if (stream->sample)
 		hrtimer_cancel(&stream->poll_check_timer);
+
+	/* Update stream->oa_buffer.tail to allow any final reports to be read */
+	if (xe_oa_buffer_check_unlocked(stream))
+		wake_up(&stream->poll_wq);
 }
 
 static int xe_oa_enable_preempt_timeslice(struct xe_oa_stream *stream)


