Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C9311C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813FDC433D2;
	Mon, 12 Jun 2023 10:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567108;
	bh=pHVimp4qoF2AHHQtcuFEHH0jos1ANwGrfKD9XFyn0yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzYPX9wlhsPvlGccKlOYh0Ox7rj7hpsEDsG9y4MIlq1oWLBOSH90hFbjdl7HbAPAz
	 uenwJlR3jvp8G+cI1oYFFA7fEiZNyW72cvrafBt4HFm2yjGP3eIyDaR8UkXh/Ui3G0
	 EXhrF3YOoD4GI4ziOMKfktN82UotSCXTO4wMWjaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Ruihan Li <lrh2000@pku.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.3 154/160] Bluetooth: Refcnt drop must be placed last in hci_conn_unlink
Date: Mon, 12 Jun 2023 12:28:06 +0200
Message-ID: <20230612101722.113596893@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ruihan Li <lrh2000@pku.edu.cn>

commit 2910431ab0e500dfc5df12299bb15eef0f30b43e upstream.

If hci_conn_put(conn->parent) reduces conn->parent's reference count to
zero, it can immediately deallocate conn->parent. At the same time,
conn->link->list has its head in conn->parent, causing use-after-free
problems in the latter list_del_rcu(&conn->link->list).

This problem can be easily solved by reordering the two operations,
i.e., first performing the list removal with list_del_rcu and then
decreasing the refcnt with hci_conn_put.

Reported-by: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Closes: https://lore.kernel.org/linux-bluetooth/CABBYNZ+1kce8_RJrLNOXd_8=Mdpb=2bx4Nto-hFORk=qiOkoCg@mail.gmail.com/
Fixes: 06149746e720 ("Bluetooth: hci_conn: Add support for linking multiple hcon")
Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1107,12 +1107,12 @@ static void hci_conn_unlink(struct hci_c
 	if (!conn->link)
 		return;
 
-	hci_conn_put(conn->parent);
-	conn->parent = NULL;
-
 	list_del_rcu(&conn->link->list);
 	synchronize_rcu();
 
+	hci_conn_put(conn->parent);
+	conn->parent = NULL;
+
 	kfree(conn->link);
 	conn->link = NULL;
 }


