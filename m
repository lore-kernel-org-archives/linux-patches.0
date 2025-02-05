Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3F68634E;
	Wed,  5 Feb 2025 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765515; cv=none; b=FNbSS7FUyBR9ZaMisMJWk7E6flcp3lqR33a0Z3Q+FkBcLAkBL7wFlqcAfTWRUZRy5FUnKx7JySV/+gw5bq8nIoFddPZErikoQ5Eb+ymBmEatLtJRHlu7IKbJc6PssktkO0i+uUiCf27/qFGP5NIbXmkpBkh2e/7idfJm64xaWTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765515; c=relaxed/simple;
	bh=603tDoYVH353fN5BLMdgAq4So19565ePcSAQWeMZLeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfnGTkL/jQpzXaTSVfdJoFC+Gq/P0ycwnOK8v+ht7Bv6bXlLe5XZFcvpQo6Opwb0i7ikJJnRws9aHbUA1ksAlc5MTGHlIif7LmpjzrVM+tPbOSpKMiDd9kT1G30GVoX80j53JX05+YjkJLsa5S19/2+jaTMInOZnJoQUPmud02M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IT2dfAwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IT2dfAwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5774CC4CED6;
	Wed,  5 Feb 2025 14:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765514;
	bh=603tDoYVH353fN5BLMdgAq4So19565ePcSAQWeMZLeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IT2dfAwJfCvGg6ZW4moyUi5AyIxeGEb5Ob1n/H7i5+o9btm6mqEOAm9KF55C0BiGD
	 IR+SNJG46BJcJJRNKIEPbaSIEc/1r71b5YdQd5Cd8vlRpebrgj4Ebj9SOdTTcP3XCY
	 dp3Eb7Ws9WGMrwl7WH7kaPr0gZ3bnN96HATZ3/DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/393] i3c: dw: Fix use-after-free in dw_i3c_master driver due to race condition
Date: Wed,  5 Feb 2025 14:43:13 +0100
Message-ID: <20250205134430.794663005@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit b75439c945b94dd8a2b645355bdb56f948052601 ]

In dw_i3c_common_probe, &master->hj_work is bound with
dw_i3c_hj_work. And dw_i3c_master_irq_handler can call
dw_i3c_master_irq_handle_ibis function to start the work.

If we remove the module which will call dw_i3c_common_remove to
make cleanup, it will free master->base through i3c_master_unregister
while the work mentioned above will be used. The sequence of operations
that may lead to a UAF bug is as follows:

CPU0                                      CPU1

                                     | dw_i3c_hj_work
dw_i3c_common_remove                 |
i3c_master_unregister(&master->base) |
device_unregister(&master->dev)      |
device_release                       |
//free master->base                  |
                                     | i3c_master_do_daa(&master->base)
                                     | //use master->base

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in dw_i3c_common_remove.

Fixes: 1dd728f5d4d4 ("i3c: master: Add driver for Synopsys DesignWare IP")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Link: https://lore.kernel.org/r/bfc49c9527be5b513e7ceafeba314ca40a5be4bc.1732703537.git.xiaopei01@kylinos.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 93e9d307e40ef..030127525672e 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1528,6 +1528,7 @@ EXPORT_SYMBOL_GPL(dw_i3c_common_probe);
 
 void dw_i3c_common_remove(struct dw_i3c_master *master)
 {
+	cancel_work_sync(&master->hj_work);
 	i3c_master_unregister(&master->base);
 
 	reset_control_assert(master->core_rst);
-- 
2.39.5



