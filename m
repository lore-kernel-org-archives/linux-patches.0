Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF133FC5A1;
	Wed, 20 May 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299955; cv=none; b=CC17AdvP+ZmILc3X9BD0LH0ljy4szPaRHfIYf5Po6io7e3xzvRGJv/ZY0QfiO//Gir8bQIpqLGxyUJxPrOhJ6IlXsYhBS9597lHyE8k4fr377mXdF3Ja/AcKWQ8I6+Rato1wMoORabAjV23+jQw0T5QP01OW2cyEALC8M7wKtD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299955; c=relaxed/simple;
	bh=HBcLyaU5r2REbPdBj83p2bYyj0Fwc8k27HJeAYkJviA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQXGciFUnfJwesdMZEiIAxjmZImpAknlrmVQ6J5tm5iWIhZaEDTyf1XA/o/UV2uyD9z2PljCDecRlvWYZUzHdVuQRzgsWyz8wOnOCPMHnAEidHHOk/WDRsLIQ3nSKThcU9uf+Nb7fZabwgG3G/TpSbH8rgsqCdw/5CGFhAE+F98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx21cfz/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx21cfz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E632A1F000E9;
	Wed, 20 May 2026 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299952;
	bh=YlG4eCTPIgO74EPgNphgP/vb01bCAm64vmePgFQ6TvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kx21cfz/pIntaVN9Ggh5i69WCUFDertkskYkPZsnpP7ExjaITGjXCWM4lX4GtjCWH
	 FH67VTAMeKBxakfDt5njCn0n3ySxyngfhQpl+18qJ6M1RZ5B/OG6tRU7WHAwGpCyKZ
	 8/nI4b6SCrz5oG4TOQysbUBjFlX4RLEQrHVDCzmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 949/957] eventfs: Use list_add_tail_rcu() for SRCU-protected children list
Date: Wed, 20 May 2026 18:23:52 +0200
Message-ID: <20260520162155.181389415@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit f67950b2887fa10df50c4317a1fe98a65bc6875b ]

Commit d2603279c7d6 ("eventfs: Use list_del_rcu() for SRCU protected
list variable") converted the removal side to pair with the
list_for_each_entry_srcu() walker in eventfs_iterate(). The insertion
in eventfs_create_dir() was left as a plain list_add_tail(), which on
weakly-ordered architectures can expose a new entry to the SRCU reader
before its list pointers and fields are observable.

Use list_add_tail_rcu() so the publication pairs with the existing
list_del_rcu() and list_for_each_entry_srcu().

Fixes: 43aa6f97c2d0 ("eventfs: Get rid of dentry pointers without refcounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260418152251.199343-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ adapted scoped_guard(mutex, &eventfs_mutex) block to explicit mutex_lock()/mutex_unlock() pair ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -732,7 +732,7 @@ struct eventfs_inode *eventfs_create_dir
 
 	mutex_lock(&eventfs_mutex);
 	if (!parent->is_freed)
-		list_add_tail(&ei->list, &parent->children);
+		list_add_tail_rcu(&ei->list, &parent->children);
 	mutex_unlock(&eventfs_mutex);
 
 	/* Was the parent freed? */


