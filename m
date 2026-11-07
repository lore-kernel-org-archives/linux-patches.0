Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062163;
	b=zsS3tk6EcX2JswzLnyhrNQ5zL+jwf3BrDBa7FvVZTxWjL8bYKHQsY/jcWZ+qpF93ASvl
	 wcb8XiVPRMJegU/UXaoe7GDMuN+npNVtrFruENAOWJgZuiTGK55M0Q/Bg0VjpLPJ/PK+R
	 0C1Bw60JDdcZohVqfjqqgKS+GuxsOjpjaiMty8y0qGpfXHfnIBMuRaWCkyYjdd4fX6UCe
	 AKANAx72+vitPOOhwSZGy3hyY+5MLUkTISuMjoXzug0Fw22wrDGeSL4nKELyKL8+ootfM
	 i5YuHq1vX0OvH1AGF1ZzErr2gWaMz+eii8jO/W5S6G9VJ+rhUfcH8bTYJn4yBws1Tew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5F/4m5GVLJfvflgeL98l3gFhljmR2bJ3IiXyyVvfv7k=;
	b=nV/tseI7um+OwY3U8uIu8uPosSa9Q3VA+mwPch80bw/U4q6lboZvhx64eorZOX7BKbC9
	 pAiNzYVFP1ihQQt8vsLsDfkpKNdXYrDCyPmrpmduPjL7BcGy1l5xd4CcoD7TfwGI7B+rg
	 7NwLAZmQrlyLihvvtAnc+6iWY8JfGBFtz9lYctq0xclvZxAb+5zgr3w8a+fDmIc29zcHF
	 a42PZ5Q9gSPXs6Qlq7cPnpXncD2AAx6+w/WZ/AGgECMfZ1RBTZcBGc8sT3dbC5lVXZsVG
	 kBnakuq+M2Q+5q4SxrDM0Lq/Nzc3592tpJRCzurisg/o3jI/Y5B3Ye1IG3lq+M9gncg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUOjvQ7N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEB1606A326;
	Sat,  7 Nov 2026 14:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUOjvQ7N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2271F0089F;
	Sat,  7 Nov 2026 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062162;
	bh=5F/4m5GVLJfvflgeL98l3gFhljmR2bJ3IiXyyVvfv7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUOjvQ7NNbPRMZfbiQ6rTeVKIM0fxXakbmJGevKhLrJWH6L+/eqKbWmYVPt++W/3A
	 qUEYZtbHyTzBdIrN+Z9eUBEvpHsIKce3mtKni3kRxiLxN8KJx6Or8/En2ECbpX0AI7
	 z9mR0gRLF+lvH1Lw5QCWen+Nwhr9Mvl7GnlzZhTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1126/1536] dm-writecache: fix uncommitted_blocks underflow
Date: Sat,  7 Nov 2026 08:52:22 -0500
Message-ID: <20261107135029.333714399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 8a0cc5f3446a324b13f62020eeddb32d6ba1c2db ]

Revert the commit 39495b12ef1cf602e6abd350dce2ef4199906531

writecache_bio_copy_ssd sets wc->uncommitted_blocks = 0; and then queues
the flush work: queue_work(wc->writeback_wq, &wc->flush_work);

It may be possible that discard is dispatched in this window, and the
discard would decrement wc->uncommitted_blocks to -1U.

Note that this bug is benign - wc->uncommitted_blocks is only used to
trigged autocommit, so decrementing it to -1U will trigger a spurious
autocommit, but won't cause any data corruption.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Fixes: 39495b12ef1c ("dm writecache: correct uncommitted_block when discarding uncommitted entry")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 069f104059654..dbcca33352251 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -898,8 +898,6 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				}
 				discarded_something = true;
 			}
-			if (!writecache_entry_is_committed(wc, e))
-				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
2.53.0



