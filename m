Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DE037C912;
	Tue, 16 Jun 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625305; cv=none; b=lxAlkY11+/G3D0Gba7LeG5fBQNnGYd15p1OQBA29ftn6meo+2EXWswt5oi0zyaGDFMyA4TWzMnPAb9JsW3wkaLwxYSnD99kxeHKXr2cJ80dNpqSZg9UKpedIw4vTGTJ0ZtedNU2WuKtpFbt72SzPvNql5cLwbuwIRoTCyZq9qSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625305; c=relaxed/simple;
	bh=kAeOEBYvVXb62aVo3sQgJYLwdXHR7+0jdUXe30wPztc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELzm4gcgeM/w2UaAliQQ8Ez8eX+AAiKdVCQSkCuazOB2Nu3dhLIz1IHrk+TH+qUF6Y0sScibgy0RiSNQaGSzKoWdFMI0Ro9aGa4TNdQdfNvFdwmF3hx9o3QT0MpIzTM8DNna61DsTQGjVXW8UMlg+ouJTJtPgO7qGbtZSogQYqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogF1pp1j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogF1pp1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BF51F000E9;
	Tue, 16 Jun 2026 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625304;
	bh=SRkwHiEVfjLsjecPXfdDfytRuU7XH7WxddISMMoUitY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogF1pp1j+rmR3NO7ccwFu4J9EAf1BhOcZvYTw+j/iZAWd4WBqYqlWWtQZmlxel8ch
	 EsoV/q1U88EBJX+fob8ERx2FJ2fwEn7FTBeVMmVCZVsmlCT97LudQ8v9K3z4lt6Xne
	 buxlankPnkGvK6Zym3XGRhJLqeHDhg3pJJbyvu9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/325] verification/rvgen: Fix options shared among commands
Date: Tue, 16 Jun 2026 20:27:59 +0530
Message-ID: <20260616145101.855256591@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 5f845ad706c0b394ae274e9a930044f78bef782e ]

After rvgen was refactored to use subparsers, the common options (-a and
-D) were left in the main parser. This meant that they needed to be
called /before/ the subcommand and using them without subcommand was
allowed. This is not the original intent.

  rvgen -D "some description" container -n name

Define the options as parent in the subparsers to allow them to be used
from both subcommands together with other options.

  rvgen container -n name -D "some description"

Fixes: 5270a0e3041c ("verification/dot2k: Replace is_container() hack with subparsers")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20260514152055.229162-7-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rvgen/__main__.py | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/verification/rvgen/__main__.py b/tools/verification/rvgen/__main__.py
index fa6fc1f4de2f7e..5198bccccd107b 100644
--- a/tools/verification/rvgen/__main__.py
+++ b/tools/verification/rvgen/__main__.py
@@ -17,14 +17,16 @@ if __name__ == '__main__':
     import sys
 
     parser = argparse.ArgumentParser(description='Generate kernel rv monitor')
-    parser.add_argument("-D", "--description", dest="description", required=False)
-    parser.add_argument("-a", "--auto_patch", dest="auto_patch",
+
+    parent_parser = argparse.ArgumentParser(add_help=False)
+    parent_parser.add_argument("-D", "--description", dest="description", required=False)
+    parent_parser.add_argument("-a", "--auto_patch", dest="auto_patch",
                         action="store_true", required=False,
                         help="Patch the kernel in place")
 
     subparsers = parser.add_subparsers(dest="subcmd", required=True)
 
-    monitor_parser = subparsers.add_parser("monitor")
+    monitor_parser = subparsers.add_parser("monitor", parents=[parent_parser])
     monitor_parser.add_argument('-n', "--model_name", dest="model_name")
     monitor_parser.add_argument("-p", "--parent", dest="parent",
                                 required=False, help="Create a monitor nested to parent")
@@ -34,7 +36,7 @@ if __name__ == '__main__':
     monitor_parser.add_argument('-t', "--monitor_type", dest="monitor_type",
                                 help=f"Available options: {', '.join(Monitor.monitor_types.keys())}")
 
-    container_parser = subparsers.add_parser("container")
+    container_parser = subparsers.add_parser("container", parents=[parent_parser])
     container_parser.add_argument('-n', "--model_name", dest="model_name", required=True)
 
     params = parser.parse_args()
-- 
2.53.0



