Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D2535CEB4;
	Tue, 26 Aug 2025 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218848; cv=none; b=EQRy1pQ1jplhDsYIYMM97apxHcbRI6kxvbsB8tAfZUZiq/vty+wAfm/Y/+JilCl0co3cL5bWJow8cTU8iynObsv5JV0Se9kNIUdB0CgDFke8ag3z7w3AkgymOIeISMIJcDjXEsyVqBdt8SiK6X3tgK73139kEbpxYMUev9ig24Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218848; c=relaxed/simple;
	bh=ZcVnp1h+CfNOAgmF1NODjQdWr5ysbP3R2IeIhx3+Wks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVU/ljWwayC3wGK2t7brogBm7wkwB5gmoi3MN9Xo0sO83uY3vlFd0RNwP5sNtAz8EADqLGN4pnXvgmKz1TNeHS2MzVOIRzMyAOhf4RSEVoK2IEIRXXsb1x0oRDxkcc5dYtzvCe+LevlgQc1+/T9NorYxLSPe4xH7TcxJaQ2GecQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuIBRxde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuIBRxde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7700C19423;
	Tue, 26 Aug 2025 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218848;
	bh=ZcVnp1h+CfNOAgmF1NODjQdWr5ysbP3R2IeIhx3+Wks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuIBRxdeNTI8r/9Dpzt42TL/+Q7mIe2tQDjmG/hqrHe3mKFrhvovb+/CH05pfIQ7Z
	 P4twDYrsX9HlbM5FcpxUYNLg8GPYBNegxG7cQsnd1X9a5asVCD7BlyBqMStaFre1yt
	 VoCi2Dx179YOw3w2tDRg8uMZY2h4q0MC7KLXJP9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 5.4 149/403] perf/core: Exit early on perf_mmap() fail
Date: Tue, 26 Aug 2025 13:07:55 +0200
Message-ID: <20250826110910.980812700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 07091aade394f690e7b655578140ef84d0e8d7b0 upstream.

When perf_mmap() fails to allocate a buffer, it still invokes the
event_mapped() callback of the related event. On X86 this might increase
the perf_rdpmc_allowed reference counter. But nothing undoes this as
perf_mmap_close() is never called in this case, which causes another
reference count leak.

Return early on failure to prevent that.

Fixes: 1e0fb9ec679c ("perf/core: Add pmu callbacks to track event mapping and unmapping")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6003,6 +6003,9 @@ unlock:
 aux_unlock:
 	mutex_unlock(&event->mmap_mutex);
 
+	if (ret)
+		return ret;
+
 	/*
 	 * Since pinned accounting is per vm we cannot allow fork() to copy our
 	 * vma.


