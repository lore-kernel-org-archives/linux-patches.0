Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D652690D5;
	Sat, 30 May 2026 17:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160513; cv=none; b=HMWJ9AvWqKvFUwW0+2Eg0EqcyLWyHJF3peBDMZx4ls2SmnP07NRlNbCdTaCwEMGaXrjmpxIWyefNJnmeNpJU9Y472C+59sJQIfN0PjrrZCmcEiFRSuldaA4XvEp6L5JvIjhRyDf/jPdzk2AM+eES3NOJuJB05bQeMe0H6HyBs4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160513; c=relaxed/simple;
	bh=NTGyYvhlWMLDqhxJ6BxtUr9l38/sgXt1sLbuFD8Vee8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABDaqO4ag8pK9UJH5dG9lLdK3mri5etmPbj9gIcNEz6XkgkPrSRN9u2HuSjZXn5ppPwdyS8ETHOD7DeYQhE4Pv4TCXVtzOqSafQv7R3OGcR68NmzNkKaMIw0jxeFXtKwOjg9kAjEMQ4yfpzcGRZHT2oVt0XuzLa7sLqxUt206JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wbp0T7Uo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wbp0T7Uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47891F00893;
	Sat, 30 May 2026 17:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160512;
	bh=4DqYgzYkhkClDoZQy9JjyG4RnoHfZ19oGaLxekOdqlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wbp0T7Uo4vh7tYJ6Zi7bM0DoDGsbPQhsk/uFuO41V6nNuIBLTct69Cjmsw3puZFEv
	 pwaQ1qR72C7gpKJQPzuRnXY3vMvFm2VORQk9KK4UiIYn/MTkOFKzfN+2StOcpl/vfS
	 cQVk6eoa7EoaPh+0W36TrMVrnsrde87wga9f1cxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 358/969] nvme-apple: drop invalid put of admin queue reference count
Date: Sat, 30 May 2026 17:58:02 +0200
Message-ID: <20260530160310.222658152@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit ba9d308ccd6732dd97ed8080d834a4a89e758e14 upstream.

Commit 03b3bcd319b3 ("nvme: fix admin request_queue lifetime") moved the
admin queue reference ->put call into nvme_free_ctrl() - a controller
device release callback performed for every nvme driver doing
nvme_init_ctrl().

nvme-apple sets refcount of the admin queue to 1 at allocation during the
probe function and then puts it twice now:

nvme_free_ctrl()
  blk_put_queue(ctrl->admin_q) // #1
  ->free_ctrl()
    apple_nvme_free_ctrl()
      blk_put_queue(anv->ctrl.admin_q) // #2

Note that there is a commit 941f7298c70c ("nvme-apple: remove an extra
queue reference") which intended to drop taking an extra admin queue
reference.  Looks like at that moment it accidentally fixed a refcount
leak, which existed since the driver's introduction.  There were two ->get
calls at driver's probe function and a single ->put inside
apple_nvme_free_ctrl().

However now after commit 03b3bcd319b3 ("nvme: fix admin request_queue
lifetime") the refcount is imbalanced again.  Fix it by removing extra
->put call from apple_nvme_free_ctrl().  anv->dev and ctrl->dev point to
the same device, so use ctrl->dev directly for simplification.  Compile
tested only.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 03b3bcd319b3 ("nvme: fix admin request_queue lifetime")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/apple.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1194,11 +1194,7 @@ static int apple_nvme_get_address(struct
 
 static void apple_nvme_free_ctrl(struct nvme_ctrl *ctrl)
 {
-	struct apple_nvme *anv = ctrl_to_apple_nvme(ctrl);
-
-	if (anv->ctrl.admin_q)
-		blk_put_queue(anv->ctrl.admin_q);
-	put_device(anv->dev);
+	put_device(ctrl->dev);
 }
 
 static const struct nvme_ctrl_ops nvme_ctrl_ops = {


