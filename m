Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B11F1F942
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1877C433C9;
	Fri, 21 Jul 2023 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956527;
	bh=C/7PE3lTUQqXGIBmi8qxzOjX7fOp1NVRE9IdJxn3L/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpPuiWuW8clKTq2XlAfB/OTUAu9zMWhydGtm5ZsiwoNwj2dkIZPYQBdpDygRNNOoH
	 cQ5YnhrCv1F08YFtgb50J20Gh1sqQGXbs0OtMuwn0a7HZLONFAoF6KI5dgGzWrKC+F
	 PJHYi6TA21f1geoyxto+HEjQO/aoPLxVYzAcB90Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.4 192/292] fs: dlm: fix missing pending to false
Date: Fri, 21 Jul 2023 18:05:01 +0200
Message-ID: <20230721160537.138422396@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit f68bb23cad1f128198074ed7b3a4c5fb03dbd9d2 upstream.

This patch sets the process_dlm_messages_pending boolean to false when
there was no message to process. It is a case which should not happen
but if we are prepared to recover from this situation by setting pending
boolean to false.

Cc: stable@vger.kernel.org
Fixes: dbb751ffab0b ("fs: dlm: parallelize lowcomms socket handling")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lowcomms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 3d3802c47b8b..5aad4d4842eb 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -898,6 +898,7 @@ static void process_dlm_messages(struct work_struct *work)
 	pentry = list_first_entry_or_null(&processqueue,
 					  struct processqueue_entry, list);
 	if (WARN_ON_ONCE(!pentry)) {
+		process_dlm_messages_pending = false;
 		spin_unlock(&processqueue_lock);
 		return;
 	}
-- 
2.41.0



