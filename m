Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D48B46D556;
	Tue, 21 Jul 2026 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648596; cv=none; b=sjY8D1UF6fMeOTYFD2KfjCmD4C7HkJh23CfLznlUzLzxeerpPudeLai3Rgvk789JinNSM34PaBHDGeI6JYmW9GTyxpyz8EWIKpZQLiekAbgD/T5WlhOpPWvj3rJgaRKt7+6WHZwjMHNn/om0PQ/UCMZRkjFcSkpz6K/BJWKuRuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648596; c=relaxed/simple;
	bh=KxZ4MbX+Upbq7YrFM1sp7gLcc3zuTmkJ9ftEjHTcXJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYTvBazgPV1h9PK1wntwm3LVCbL5QI7gV/6tVp5NSyDuHp0fpj7k+pKL6Nfc7I7AF+nvsnzDU6OH7Xa9eTZxruBp09XOstVQmHyk8NIDv7mK0yA6EkJC8MxSVnbSZIl58e5sTfy1oaV+fQNKF/EOgGlI0YSdQEW+9V7xv7rzRHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsfCHiVQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsfCHiVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B581F000E9;
	Tue, 21 Jul 2026 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648595;
	bh=xA+DC18BTAw60aBeLigR8XGnTseKxgmNyytKVXCM9hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsfCHiVQKw6b/I+afLj+wDO2pzEamZ5XB2WnmelbvmDSmuO4kPBeHictxD4RmRfsG
	 ePYVDowrE8io7yCwock8hFaes1lmIVF5jLhNkH8+NWMtFaVog1JHSE6+ZTHPW5+rx5
	 M35uLG4oCFLewr5is4vv+3qxG38TsTiG0U5pqtVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Kevin Tian <kevin.tian@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0258/2077] vfio/xe: avoid duplicate reset in xe_vfio_pci_reset_done
Date: Tue, 21 Jul 2026 16:58:51 +0200
Message-ID: <20260721152558.765018257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

[ Upstream commit b9285405c5f6144f4444f97bf3048d865e11cc1d ]

xe_vfio_pci_reset_done() sets deferred_reset and, when it manages to
acquire state_mutex itself, hands the cleanup off to
xe_vfio_pci_state_mutex_unlock().

That helper already clears deferred_reset and runs xe_vfio_pci_reset()
before dropping the mutex. Calling xe_vfio_pci_reset() again right
afterwards repeats the reset handling unnecessarily.

Fixes: 1f5556ec8b9e ("vfio/xe: Add device specific vfio_pci driver variant for Intel graphics")
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michał Winiarski <michal.winiarski@intel.com>
Link: https://lore.kernel.org/r/20260427012128.117051-1-zhaoguohan@kylinos.cn
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/xe/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/vfio/pci/xe/main.c b/drivers/vfio/pci/xe/main.c
index 4ecadbbfd86ec7..cbff5af385ef53 100644
--- a/drivers/vfio/pci/xe/main.c
+++ b/drivers/vfio/pci/xe/main.c
@@ -135,8 +135,6 @@ static void xe_vfio_pci_reset_done(struct pci_dev *pdev)
 	}
 	spin_unlock(&xe_vdev->reset_lock);
 	xe_vfio_pci_state_mutex_unlock(xe_vdev);
-
-	xe_vfio_pci_reset(xe_vdev);
 }
 
 static const struct pci_error_handlers xe_vfio_pci_err_handlers = {
-- 
2.53.0



