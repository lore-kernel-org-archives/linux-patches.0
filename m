Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061050;
	b=cHfk5bpK/DGUuFXeimVQL4cjs5HijGdG/+TfxLBYDfuDPv1dtLKM+a0A8TjFq0giTCnA
	 A6AvHA4rzxBxZTHTRjzWWzNull02dLwmYoPUONL8G+hIvoJD8Zu99cOdxvCdDaJ0zD4MN
	 kvtTUgkhLWyZrrunTU7cqlS/z3F8FE2/HE10/rcOX8Iy7X0BiFXqzjhHyuUgfej2HW5kC
	 qBaCwTcjKQgU3EKj9u2XDWZxjCeGNWXcPqX2S8X6SDmQ5Tuw/7aPicB6BmTaDjn+S19t5
	 ysNoEU66iMMEow6fC3UoMds3suC8NzAAJ7BkulK1W1P5sktSWP1qTD1BuKSgRYgyoXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mno5uSnTAnXpl8nn0eKbIqaIFqCwQBcaMDfvBpmNJLQ=;
	b=GC/8AJnTH8OIkC3Nyq+IhMZVvXpgBX75vIsnxP8iCqrZVEo8RDATMQGA3onPOctGl3FT
	 PuazIsFLtiYEntTUTpdZRc8i4jRavZJ5q3yKoq6HSg6p44xZL7IAKyQcO30gO2j+1aNih
	 yEjzjZ77lNCP5PtR9/Q1jyMy3YI7aRR8dVykJ4ugiflOCMGMtI60DxbrqaVT4IBeufN3q
	 aSdSe7ee/bOghAcwlJ4Dh9x8bBro6ljWiGx/HU5I3i/ZLWjbja2VIWzBRC0slrtiBlPgF
	 ZYBZBvCLcbYGZKlwBHq/JlkNYw15vXvVgtt+cYsP5UCEU9GO48dr0+AJo+35QoCpOkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pofLBQH8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0161B606A326;
	Thu, 19 Nov 2026 04:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pofLBQH8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490481F000C4;
	Thu, 19 Nov 2026 04:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061049;
	bh=Mno5uSnTAnXpl8nn0eKbIqaIFqCwQBcaMDfvBpmNJLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pofLBQH8Cli/bdk+YJZk+Ttg/bgLS7EW0pLPv4GmhAqVrArWRy2ekM+9YnUKnQP4p
	 pjSYLiuUQvGBj8ry7m+t1Ydrjf6Yix35i87+0otxbQl10I0Pbg0QG0jfgYpE4kGIAc
	 KC/WVU+0I6F1GUy4BrSoPJb+6HiwBCgDZEUtE11U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1413/1848] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Date: Wed, 18 Nov 2026 15:57:31 +0100
Message-ID: <20261118150018.653009159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e95d076bc1fca7cc36fc8f2f0e9687f79fd314bd ]

The SDMA state reference and completion cover the software cleanup
tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
flush_worker. Queued instances can therefore access an SDMA engine after
per_sdma is released.

After the state machine has stopped, cancel err_halt_worker first
because it can publish the hardware cleanup tasklet. Then kill that
tasklet and drain the remaining flush work.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134148.977-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 68a8557e9a7c4..c3c1c04b6c027 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1625,6 +1625,9 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 * it is not running.
 		 */
 		sdma_finalput(&sde->state);
+		cancel_work_sync(&sde->err_halt_worker);
+		tasklet_kill(&sde->sdma_hw_clean_up_task);
+		cancel_work_sync(&sde->flush_worker);
 	}
 }
 
-- 
2.53.0



