Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A139A11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BD1C433C7;
	Mon, 11 Sep 2023 14:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443582;
	bh=AFcrhsyO6kDKuqQ7hIob3ohVT+H9kALfRNawwZprJ/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5b2LpSkimUP9bh99B4GYHPwSahnL5IUgC0Be7yaKJmHFhkcDvC0s4hQMJ4MGY63/
	 deoHRXNjzpldL6g3vDMPuij11Xcd0oKo71HkTSwoGwJc48x1JnKfOPffHoy33UNxtk
	 V2MCU9aG+xLfHJevM+m3jmQLXYgvz0z7jmtiJ5R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ira Weiny <ira.weiny@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 421/737] PCI/DOE: Fix destroy_work_on_stack() race
Date: Mon, 11 Sep 2023 15:44:40 +0200
Message-ID: <20230911134702.366151130@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ira Weiny <ira.weiny@intel.com>

[ Upstream commit e3a3a097eaebaf234a482b4d2f9f18fe989208c1 ]

The following debug object splat was observed in testing:

  ODEBUG: free active (active state 0) object: 0000000097d23782 object type: work_struct hint: doe_statemachine_work+0x0/0x510
  WARNING: CPU: 1 PID: 71 at lib/debugobjects.c:514 debug_print_object+0x7d/0xb0
  ...
  Workqueue: pci 0000:36:00.0 DOE [1 doe_statemachine_work
  RIP: 0010:debug_print_object+0x7d/0xb0
  ...
  Call Trace:
   ? debug_print_object+0x7d/0xb0
   ? __pfx_doe_statemachine_work+0x10/0x10
   debug_object_free.part.0+0x11b/0x150
   doe_statemachine_work+0x45e/0x510
   process_one_work+0x1d4/0x3c0

This occurs because destroy_work_on_stack() was called after signaling
the completion in the calling thread.  This creates a race between
destroy_work_on_stack() and the task->work struct going out of scope in
pci_doe().

Signal the work complete after destroying the work struct.  This is safe
because signal_task_complete() is the final thing the work item does and
the workqueue code is careful not to access the work struct after.

Fixes: abf04be0e707 ("PCI/DOE: Fix memory leak with CONFIG_DEBUG_OBJECTS=y")
Link: https://lore.kernel.org/r/20230726-doe-fix-v1-1-af07e614d4dd@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/doe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index 1b97a5ab71a96..e3aab5edaf706 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -293,8 +293,8 @@ static int pci_doe_recv_resp(struct pci_doe_mb *doe_mb, struct pci_doe_task *tas
 static void signal_task_complete(struct pci_doe_task *task, int rv)
 {
 	task->rv = rv;
-	task->complete(task);
 	destroy_work_on_stack(&task->work);
+	task->complete(task);
 }
 
 static void signal_task_abort(struct pci_doe_task *task, int rv)
-- 
2.40.1



