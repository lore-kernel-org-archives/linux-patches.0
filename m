Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEC029B20E;
	Tue, 25 Mar 2025 12:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905852; cv=none; b=jf3UKKxpdM1HI9q7MhGUKLSYoAw9qwC9DptQ0xEzaj6xE826qQqki5RJf84L1092Q2e+WKFD4Dt+HJyhQIK3VneXjwPgpwTUWK/HjqxA6H1nq+K7fLqeqO10lejvwXMuDeX1YsXMS9Op4n8NX+3dV26xbcOyYGohhQOgCL91t3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905852; c=relaxed/simple;
	bh=kQWzNjhkOdA0tsI+cF/FnKW6c7ABXarfo7I9mdlEsXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbB0le0dcsPBvgOBfoWxMwmM3GgGONjG2DdUKdcYcz1fyviFqMwyyD9xSShqHBO5Wlt1Z3z6ZIu8MPXyOX4516pAWL278gQ30HgDKynNx94PuY1Es2ArhsyA+3ECcxZdQA86TvAw7khqie/MaikPThwzVToeIxIWBcF5QyCAVaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+pC8M6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+pC8M6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCA0C4CEEF;
	Tue, 25 Mar 2025 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905852;
	bh=kQWzNjhkOdA0tsI+cF/FnKW6c7ABXarfo7I9mdlEsXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+pC8M6Hb9xd8a1qChfQaBY1C6KIJKRFxZAfu7k8ZYTBMyviW5XJFbZkkZb8IIQiw
	 wKrAEalp56krzoy7XxdUqh908EkJhvpT8lG0CliXfCok63F8RiwKmZJU+2niOkSgyo
	 0l/jgSyCS7q6NEuhFDg3DYop7lHiLY4b0yoXmYzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Acs <acsjakub@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>
Subject: [PATCH 6.1 198/198] block, bfq: fix re-introduced UAF in bic_set_bfqq()
Date: Tue, 25 Mar 2025 08:22:40 -0400
Message-ID: <20250325122201.847674082@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Acs, Jakub" <acsjakub@amazon.de>

Commit eca0025faa96ac ("block, bfq: split sync bfq_queues on a
per-actuator basis"), which is a backport of 9778369a2d6c5e ("block,
bfq: split sync bfq_queues on a per-actuator basis") re-introduces UAF
bug originally fixed by b600de2d7d3a16 ("block, bfq: fix uaf for bfqq in
bic_set_bfqq()") and backported to 6.1 in cb1876fc33af26 ("block, bfq:
fix uaf for bfqq in bic_set_bfqq()").

bfq_release_process_ref() may release the sync_bfqq variable, which
points to the same bfqq as bic->bfqq member for call context from
__bfq_bic_change_cgroup(). bic_set_bfqq() then accesses bic->bfqq member
which leads to the UAF condition.

Fix this by bringing the incriminated function calls back in correct
order.

Fixes: eca0025faa96ac ("block, bfq: split sync bfq_queues on a per-actuator basis")
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Cc: Hagar Hemdan <hagarhem@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -739,8 +739,8 @@ static void bfq_sync_bfqq_move(struct bf
 		 * old cgroup.
 		 */
 		bfq_put_cooperator(sync_bfqq);
-		bfq_release_process_ref(bfqd, sync_bfqq);
 		bic_set_bfqq(bic, NULL, true, act_idx);
+		bfq_release_process_ref(bfqd, sync_bfqq);
 	}
 }
 


