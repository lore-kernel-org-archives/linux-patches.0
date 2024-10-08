Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BEE1CCB32;
	Tue,  8 Oct 2024 12:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390802; cv=none; b=knFR8WkGSJPc8FqYLnqf6Nu2DoGYclbGtyFtfXDLcMSbpxNN8ifGCy4M9QbVnWFifpPAHI6/Q2g/e1Tjc9wE3cYo1qdQinp4IyhJm6Yv8Iy55+Qm/iyGyLOVEK4X4GbT8rv8kFsIe2d0zXNVcA8fVJ0VCclo9m2CFf+EK/fwWJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390802; c=relaxed/simple;
	bh=Sq7cDm2UdVfWrkt/TnNpUiebe+JMWartlEmz6v0qMrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMqKZG8xNfK3i9Wx09YfDUQxfgzTDXITpfe53n8M4SIAyve7RpL2feppJLT9oNVPNPrEejvV/LC/cEwzBJK/f7AY9A9O1VG1RJ76xB6Y6+tdAYtBhBKygD7bx6BYgisoEFvmvYn5FAzBnf4qcNhb8chG7znkh24O1cOgETVWp8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnaabz/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnaabz/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F15C4CEC7;
	Tue,  8 Oct 2024 12:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390802;
	bh=Sq7cDm2UdVfWrkt/TnNpUiebe+JMWartlEmz6v0qMrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnaabz/KSzbkg0+7a30/xf1cNbz0XEqZTTG2LP0yVlQuSKstXL2IvxyKyeX26iudj
	 lLCFPm5CXYWmJfS4aAHQp6QUKV/CCP8IlIYC4RYMo26wU8YqHzsMNWN2C95+lLUexy
	 TAZosdItWl95OSnp9TPZvzj3VbNkV3SVA6EEFi2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Esmat <youssefesmat@google.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 6.10 366/482] sched/core: Clear prev->dl_server in CFS pick fast path
Date: Tue,  8 Oct 2024 14:07:09 +0200
Message-ID: <20241008115702.825392518@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Esmat <youssefesmat@google.com>

commit a741b82423f41501e301eb6f9820b45ca202e877 upstream.

In case the previous pick was a DL server pick, ->dl_server might be
set. Clear it in the fast path as well.

Fixes: 63ba8422f876 ("sched/deadline: Introduce deadline servers")
Signed-off-by: Youssef Esmat <youssefesmat@google.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/7f7381ccba09efcb4a1c1ff808ed58385eccc222.1716811044.git.bristot@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6044,6 +6044,13 @@ __pick_next_task(struct rq *rq, struct t
 		}
 
 		/*
+		 * This is a normal CFS pick, but the previous could be a DL pick.
+		 * Clear it as previous is no longer picked.
+		 */
+		if (prev->dl_server)
+			prev->dl_server = NULL;
+
+		/*
 		 * This is the fast path; it cannot be a DL server pick;
 		 * therefore even if @p == @prev, ->dl_server must be NULL.
 		 */


