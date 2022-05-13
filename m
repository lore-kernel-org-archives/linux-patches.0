Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84074C74
	for <patches@lists.linux.dev>; Fri, 13 May 2022 19:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/APt/fREJUivm2PL8Qip+DxLUsOoVfNgqWfQfNmKkEM=; b=2L3lR8RT+ik15tlc3Fk0Zwr327
	vxDNvlTDagP9N62xnZg5ps/Lo3KS5NHaRwxIkc1EHB5WJGyy9nZtqAh/snrNzXOc4eIOirgqZWhjj
	Rg6CDQPJKppnwByCq2hXFIXhQfj+p8d5oaq+6IEJIxq7nlQhI8+3qaDXgF7LQ0qTQOSQ7Go8mcVL5
	scX/ZXtnvESB9XTqpwLzX3zjT2O2RD99aSjGj3QR4rfKC/3GzrYomRPI6qbOtm+M5mWSrKgxs+GLH
	igbFNYm7tbCIL98z9YO40Cng6tFVpHquoatLkTQQK86hsE9pHEuzEuBQ7Sb5+L+xZVJ+yI81mep2K
	/7QMUxfQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1npb7T-00HM1z-IL; Fri, 13 May 2022 19:38:35 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Cc: patches@lists.linux.dev,
	amir73il@gmail.com,
	pankydev8@gmail.com,
	tytso@mit.edu,
	josef@toxicpanda.com,
	jmeneghi@redhat.com,
	jake@lwn.net,
	mcgrof@kernel.org
Subject: [PATCH 2/4] kdevops: move generic kdevops variables to its own file
Date: Fri, 13 May 2022 12:38:29 -0700
Message-Id: <20220513193831.4136212-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513193831.4136212-1-mcgrof@kernel.org>
References: <20220513193831.4136212-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

There are shared kdevops variables between different workflows,
which *can* be used by any workflow. Move these into a generic
kdevops helper Makefile, as we can later expand on this.

This makes no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 workflows/Makefile        | 33 +--------------------------------
 workflows/common/Makefile | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 32 deletions(-)
 create mode 100644 workflows/common/Makefile

diff --git a/workflows/Makefile b/workflows/Makefile
index 928e42f..033ffc7 100644
--- a/workflows/Makefile
+++ b/workflows/Makefile
@@ -1,37 +1,6 @@
 # SPDX-License-Identifier: copyleft-next-0.3.1
 
-# How we create the partition for the workflow data partition
-WORKFLOW_DATA_DEVICE:=$(subst ",,$(CONFIG_WORKFLOW_DATA_DEVICE))
-WORKFLOW_DATA_PATH:=$(subst ",,$(CONFIG_WORKFLOW_DATA_PATH))
-WORKFLOW_DATA_FSTYPE:=$(subst ",,$(CONFIG_WORKFLOW_DATA_FSTYPE))
-WORKFLOW_DATA_LABEL:=$(subst ",,$(CONFIG_WORKFLOW_DATA_LABEL))
-
-WORKFLOW_KDEVOPS_GIT:=$(subst ",,$(CONFIG_WORKFLOW_KDEVOPS_GIT))
-WORKFLOW_KDEVOPS_GIT_DATA:=$(subst ",,$(CONFIG_WORKFLOW_KDEVOPS_GIT_DATA))
-WORKFLOW_KDEVOPS_DIR:=$(subst ",,$(CONFIG_WORKFLOW_KDEVOPS_DIR))
-
-WORKFLOW_ARGS	+= data_device=$(WORKFLOW_DATA_DEVICE)
-WORKFLOW_ARGS	+= data_path=$(WORKFLOW_DATA_PATH)
-WORKFLOW_ARGS	+= data_fstype=$(WORKFLOW_DATA_FSTYPE)
-WORKFLOW_ARGS	+= data_label=$(WORKFLOW_DATA_LABEL)
-WORKFLOW_ARGS	+= kdevops_git=$(WORKFLOW_KDEVOPS_GIT)
-WORKFLOW_ARGS	+= kdevops_data=\"$(WORKFLOW_KDEVOPS_GIT_DATA)\"
-WORKFLOW_ARGS	+= kdevops_dir=\"$(WORKFLOW_KDEVOPS_DIR)\"
-
-ifeq (y,$(CONFIG_WORKFLOW_MAKE_CMD_OVERRIDE))
-WORKFLOW_MAKE_CMD:=$(subst ",,$(CONFIG_WORKFLOW_MAKE_CMD))
-endif
-
-ifeq (y,$(CONFIG_WORKFLOW_INFER_USER_AND_GROUP))
-WORKFLOW_ARGS	+= infer_uid_and_group=True
-else
-WORKFLOW_DATA_USER:=$(subst ",,$(CONFIG_WORKFLOW_DATA_USER))
-WORKFLOW_DATA_GROUP:=$(subst ",,$(CONFIG_WORKFLOW_DATA_GROUP))
-
-WORKFLOW_ARGS	+= data_user=$(WORKFLOW_DATA_USER)
-WORKFLOW_ARGS	+= data_group=$(WORKFLOW_DATA_GROUP)
-
-endif # CONFIG_WORKFLOW_MAKE_CMD_OVERRIDE == y
+include workflows/common/Makefile
 
 BOOTLINUX_ARGS	:=
 ifeq (y,$(CONFIG_BOOTLINUX))
diff --git a/workflows/common/Makefile b/workflows/common/Makefile
new file mode 100644
index 0000000..da21d78
--- /dev/null
+++ b/workflows/common/Makefile
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: copyleft-next-0.3.1
+
+# How we create the partition for the workflow data partition
+WORKFLOW_DATA_DEVICE:=$(subst ",,$(CONFIG_WORKFLOW_DATA_DEVICE))
+WORKFLOW_DATA_PATH:=$(subst ",,$(CONFIG_WORKFLOW_DATA_PATH))
+WORKFLOW_DATA_FSTYPE:=$(subst ",,$(CONFIG_WORKFLOW_DATA_FSTYPE))
+WORKFLOW_DATA_LABEL:=$(subst ",,$(CONFIG_WORKFLOW_DATA_LABEL))
+
+WORKFLOW_KDEVOPS_GIT:=$(subst ",,$(CONFIG_WORKFLOW_KDEVOPS_GIT))
+WORKFLOW_KDEVOPS_GIT_DATA:=$(subst ",,$(CONFIG_WORKFLOW_KDEVOPS_GIT_DATA))
+WORKFLOW_KDEVOPS_DIR:=$(subst ",,$(CONFIG_WORKFLOW_KDEVOPS_DIR))
+
+WORKFLOW_ARGS	+= data_device=$(WORKFLOW_DATA_DEVICE)
+WORKFLOW_ARGS	+= data_path=$(WORKFLOW_DATA_PATH)
+WORKFLOW_ARGS	+= data_fstype=$(WORKFLOW_DATA_FSTYPE)
+WORKFLOW_ARGS	+= data_label=$(WORKFLOW_DATA_LABEL)
+WORKFLOW_ARGS	+= kdevops_git=$(WORKFLOW_KDEVOPS_GIT)
+WORKFLOW_ARGS	+= kdevops_data=\"$(WORKFLOW_KDEVOPS_GIT_DATA)\"
+WORKFLOW_ARGS	+= kdevops_dir=\"$(WORKFLOW_KDEVOPS_DIR)\"
+
+ifeq (y,$(CONFIG_WORKFLOW_MAKE_CMD_OVERRIDE))
+WORKFLOW_MAKE_CMD:=$(subst ",,$(CONFIG_WORKFLOW_MAKE_CMD))
+endif
+
+ifeq (y,$(CONFIG_WORKFLOW_INFER_USER_AND_GROUP))
+WORKFLOW_ARGS	+= infer_uid_and_group=True
+else
+WORKFLOW_DATA_USER:=$(subst ",,$(CONFIG_WORKFLOW_DATA_USER))
+WORKFLOW_DATA_GROUP:=$(subst ",,$(CONFIG_WORKFLOW_DATA_GROUP))
+
+WORKFLOW_ARGS	+= data_user=$(WORKFLOW_DATA_USER)
+WORKFLOW_ARGS	+= data_group=$(WORKFLOW_DATA_GROUP)
+
+endif # CONFIG_WORKFLOW_INFER_USER_AND_GROUP == y
-- 
2.35.1

