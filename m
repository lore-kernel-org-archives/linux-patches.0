Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D5C1420BE;
	Tue, 23 Apr 2024 21:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908702; cv=none; b=IUKhkhgMKShzvjlNaQ3QjalBrteBiosh72m5DA4zvejSAgLAz+G2kV4Urd7XXLpacfgQI5llxn01Ev+exH49kg7PT6kTxvpFWfdXBxKx4ucFkVwWRnqaT4HrtVA6hrQxlTE/SI29gsAFcfZERM83sZU0YoLV48LQMHie0jPEixw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908702; c=relaxed/simple;
	bh=dgAHx0Gs9baK7jfjqPk/LuJpoV3ETOGFsZpHBTZzcKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGuMvU1DsobmUHROW5AMfQIvgKhNjEughuhTkQNf5ojrB00oHgpV/l7bcju3gl+BdALqF0k4G/Jv0lpf4BAwXe+RsYJbIykYmA22hDAxvm9NDXRVt/fMzzbBeRu8py3EHR0mF9ouI5t3+d6zbuY8dQWCG+otILt7g+Z1f4AVet4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLmvlqcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLmvlqcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A69AC116B1;
	Tue, 23 Apr 2024 21:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908702;
	bh=dgAHx0Gs9baK7jfjqPk/LuJpoV3ETOGFsZpHBTZzcKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLmvlqcAj4QdJ/XzKQzNgVocemmwuCO3sW9IvdHIPA69mHn4zDmmkAQbDsjfUW/EY
	 qChS98aoc5mXxhn5z835zy3Eg0YXibc8p3N+SorfXijOMCFvfnyO0RzMUCM/pIXcVS
	 lSUdKH4DmcfmIsgWOuTJVg2i0Y6C/cJHamVchaEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yanjun.Zhu" <yanjun.zhu@linux.dev>,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/141] RDMA/rxe: Fix the problem "mutex_destroy missing"
Date: Tue, 23 Apr 2024 14:38:36 -0700
Message-ID: <20240423213854.821043654@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanjun.Zhu <yanjun.zhu@linux.dev>

[ Upstream commit 481047d7e8391d3842ae59025806531cdad710d9 ]

When a mutex lock is not used any more, the function mutex_destroy
should be called to mark the mutex lock uninitialized.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yanjun.Zhu <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20240314065140.27468-1-yanjun.zhu@linux.dev
Reviewed-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 51daac5c4feb7..be3ddfbf3cae3 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -33,6 +33,8 @@ void rxe_dealloc(struct ib_device *ib_dev)
 
 	if (rxe->tfm)
 		crypto_free_shash(rxe->tfm);
+
+	mutex_destroy(&rxe->usdev_lock);
 }
 
 /* initialize rxe device parameters */
-- 
2.43.0



