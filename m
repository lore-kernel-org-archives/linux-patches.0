Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97961208D8
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q49E9jz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131A9C433C8;
	Tue, 31 Oct 2023 17:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774653;
	bh=P6cDMcdo1o+HAQAReHR6aFq7oN5Q1IFm2fJALjITWKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q49E9jz2J4+wjvG8AWcDEjClXZoeTyRns6U+a7v7ytkf8n+AT4VNvQWdsUQ8GXLvx
	 rGYEk/JKmQrz7mBHp5w/eMTjCJuyVxodOZCU469niSWS8Dt9HkZn4h+cjULTaT01Qo
	 fbLt/9IuAcEXiupKSBqzg6q3AjctQ/WIn8DeXEHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Daly <pdaly@redhat.com>,
	"Alessandro Carminati (Red Hat)" <alessandro.carminati@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.5 107/112] clk: Sanitize possible_parent_show to Handle Return Value of of_clk_get_parent_name
Date: Tue, 31 Oct 2023 18:01:48 +0100
Message-ID: <20231031165904.642846297@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Carminati <alessandro.carminati@gmail.com>

commit ceb87a361d0b079ecbc7d2831618c19087f304a9 upstream.

In the possible_parent_show function, ensure proper handling of the return
value from of_clk_get_parent_name to prevent potential issues arising from
a NULL return.
The current implementation invokes seq_puts directly on the result of
of_clk_get_parent_name without verifying the return value, which can lead
to kernel panic if the function returns NULL.

This patch addresses the concern by introducing a check on the return
value of of_clk_get_parent_name. If the return value is not NULL, the
function proceeds to call seq_puts, providing the returned value as
argument.
However, if of_clk_get_parent_name returns NULL, the function provides a
static string as argument, avoiding the panic.

Fixes: 1ccc0ddf046a ("clk: Use seq_puts() in possible_parent_show()")
Reported-by: Philip Daly <pdaly@redhat.com>
Signed-off-by: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
Link: https://lore.kernel.org/r/20230921073217.572151-1-alessandro.carminati@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3416,6 +3416,7 @@ static void possible_parent_show(struct
 				 unsigned int i, char terminator)
 {
 	struct clk_core *parent;
+	const char *name = NULL;
 
 	/*
 	 * Go through the following options to fetch a parent's name.
@@ -3430,18 +3431,20 @@ static void possible_parent_show(struct
 	 * registered (yet).
 	 */
 	parent = clk_core_get_parent_by_index(core, i);
-	if (parent)
+	if (parent) {
 		seq_puts(s, parent->name);
-	else if (core->parents[i].name)
+	} else if (core->parents[i].name) {
 		seq_puts(s, core->parents[i].name);
-	else if (core->parents[i].fw_name)
+	} else if (core->parents[i].fw_name) {
 		seq_printf(s, "<%s>(fw)", core->parents[i].fw_name);
-	else if (core->parents[i].index >= 0)
-		seq_puts(s,
-			 of_clk_get_parent_name(core->of_node,
-						core->parents[i].index));
-	else
-		seq_puts(s, "(missing)");
+	} else {
+		if (core->parents[i].index >= 0)
+			name = of_clk_get_parent_name(core->of_node, core->parents[i].index);
+		if (!name)
+			name = "(missing)";
+
+		seq_puts(s, name);
+	}
 
 	seq_putc(s, terminator);
 }


