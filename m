Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AEA2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD12C4331E;
	Wed, 12 Apr 2023 08:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288901;
	bh=No/o7Nw40NJctC95qme3wB0FA3XKx6bh26qzevsE4PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZQYIMrsmVWM0Wr/QH5H177wQF8GedvhhzpHHquiiiU0abFJc6v2kBGqleneqDfFe
	 FWotFwPkK3LazN24w9rIE8KE7ScfensT37U9bRmiJm546gNPctm60cxMcVNppQHXm4
	 NUP9gSZs8h+gYoy8wfM/bb9qBhDrv18f+vIAhQpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ira Weiny <ira.weiny@intel.com>,
	Lukas Wunner <lukas@wunner.de>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 061/164] PCI/DOE: Fix memory leak with CONFIG_DEBUG_OBJECTS=y
Date: Wed, 12 Apr 2023 10:33:03 +0200
Message-Id: <20230412082839.410632625@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lukas Wunner <lukas@wunner.de>

commit abf04be0e7071f2bcd39bf97ba407e7d4439785e upstream.

After a pci_doe_task completes, its work_struct needs to be destroyed
to avoid a memory leak with CONFIG_DEBUG_OBJECTS=y.

Fixes: 9d24322e887b ("PCI/DOE: Add DOE mailbox support functions")
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: stable@vger.kernel.org # v6.0+
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/775768b4912531c3b887d405fc51a50e465e1bf9.1678543498.git.lukas@wunner.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/doe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index c14ffdf23f87..e5e9b287b976 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -224,6 +224,7 @@ static void signal_task_complete(struct pci_doe_task *task, int rv)
 {
 	task->rv = rv;
 	task->complete(task);
+	destroy_work_on_stack(&task->work);
 }
 
 static void signal_task_abort(struct pci_doe_task *task, int rv)
-- 
2.40.0



