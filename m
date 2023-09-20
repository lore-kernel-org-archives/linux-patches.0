Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0068465
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B659DC433C9;
	Wed, 20 Sep 2023 11:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210706;
	bh=vikRSlR5Thp3Gb7EfDPdlFhMWVXMYvFrE2KF0c/iOv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xgo3xOJhf/ihI4J5aw9SHNvvUmV16sZ/kLoFRsCSqXDxCqPvKkH7W6c3uSefcDmFn
	 ZmcDt/oxfVwEJSbeX9vIsoBaGGN1wQ0wpajoY6zmwwFz17USE1ftTQ7a/5Ap506mv4
	 yFhuxP73oyDKWj9/vi00zEMgPmao5g8xN0CXus3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AceLan Kao <acelan@gmail.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.5 174/211] md: Put the right device in md_seq_next
Date: Wed, 20 Sep 2023 13:30:18 +0200
Message-ID: <20230920112851.277624057@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

commit c8870379a21fbd9ad14ca36204ccfbe9d25def43 upstream.

If there are multiple arrays in system and one mddevice is marked
with MD_DELETED and md_seq_next() is called in the middle of removal
then it _get()s proper device but it may _put() deleted one. As a result,
active counter may never be zeroed for mddevice and it cannot
be removed.

Put the device which has been _get with previous md_seq_next() call.

Cc: stable@vger.kernel.org
Fixes: 12a6caf27324 ("md: only delete entries from all_mddevs when the disk is freed")
Reported-by: AceLan Kao <acelan@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217798
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230914152416.10819-1-mariusz.tkaczyk@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8214,7 +8214,7 @@ static void *md_seq_next(struct seq_file
 	spin_unlock(&all_mddevs_lock);
 
 	if (to_put)
-		mddev_put(mddev);
+		mddev_put(to_put);
 	return next_mddev;
 
 }


