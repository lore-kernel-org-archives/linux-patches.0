Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3395179DC;
	Sat, 30 Dec 2023 12:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoP97OTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC9CC433C7;
	Sat, 30 Dec 2023 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938329;
	bh=BNd+g1IENqyDeKtKybwysbbrJ2ZVAzEwmpnsH5P1ovQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoP97OTYOhUm3mGe1sBRh4hQVsYueKfrAVLAvQEE/e4CijIrBYMHoMCVy62JkrDa2
	 V81A8qgO6G+GssMFlqzZJzMV4ceBnq8ii5r5rGMsYt+9OrKyJwCawkRXuJubb6T9t6
	 VS6YdoXUN9RLl2qE1OarqvBuwX1TDx4kAg4q3ERI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaxiong Tian <tianyaxiong@kylinos.cn>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 104/112] thunderbolt: Fix memory leak in margining_port_remove()
Date: Sat, 30 Dec 2023 12:00:17 +0000
Message-ID: <20231230115810.102488269@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Yaxiong Tian <tianyaxiong@kylinos.cn>

commit ac43c9122e4287bbdbe91e980fc2528acb72cc1e upstream.

The dentry returned by debugfs_lookup() needs to be released by calling
dput() which is missing in margining_port_remove(). Fix this by calling
debugfs_lookup_and_remove() that combines both and avoids the memory leak.

Fixes: d0f1e0c2a699 ("thunderbolt: Add support for receiver lane margining")
Cc: stable@vger.kernel.org
Signed-off-by: Yaxiong Tian <tianyaxiong@kylinos.cn>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -943,7 +943,7 @@ static void margining_port_remove(struct
 	snprintf(dir_name, sizeof(dir_name), "port%d", port->port);
 	parent = debugfs_lookup(dir_name, port->sw->debugfs_dir);
 	if (parent)
-		debugfs_remove_recursive(debugfs_lookup("margining", parent));
+		debugfs_lookup_and_remove("margining", parent);
 
 	kfree(port->usb4->margining);
 	port->usb4->margining = NULL;


