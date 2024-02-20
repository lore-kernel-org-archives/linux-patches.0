Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE5C1509B1;
	Tue, 20 Feb 2024 21:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464213; cv=none; b=SOamEJ8CxkuOT2suN8GtXOZ3hnEFqdXvAhMsq1mRd2WBq/7fV5n3QLu3iwoDVWrD2fSS6+M76OmD5uu8T1q9th++MTTtuSMtcvS3SZkla9ScMJMWZ+Pmq3m9gvEqyb81QfUwzsyLcHlXFa/us9gdE3akEZNVhXqc/dssCpRbEFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464213; c=relaxed/simple;
	bh=Ua4HbbEq4bT47c7ouwJ3UI0Q5GxLgUW/fUtXDpV+YHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHaPUqXfk6eeD+Zt8Yf6qj1gkQAFCrGsqDcSqnNgy+69CeyDkaB2jn5rDyEwOoX/FoWgorABVvbn3sgQYACoSwB4gjBHvVpcY6gpTi44F4anGHUCjjpj4OFF3LBCOUIthXBGf1sLoazalBCFZgLJ/9dGWr3CAsJpYicCmGJBHpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b89LySNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b89LySNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2932C433C7;
	Tue, 20 Feb 2024 21:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464213;
	bh=Ua4HbbEq4bT47c7ouwJ3UI0Q5GxLgUW/fUtXDpV+YHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b89LySNnYf4gx/Vs1M1FvLbOuDk6hH2K6yePO+YchuCSQy7WyBPXtioSoBBBXOWWS
	 u0sq7YVYyf85HZGvZdwVpK2FQR0KANfpD1OXDvfUVCD8fl0n9D33O9cws74LHXtrgD
	 yLPg/NcbfqOx9YzKu/LI1kWJuzkjTcA+xq0W7EQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 287/331] eventfs: Fix events beyond NAME_MAX blocking tasks
Date: Tue, 20 Feb 2024 21:56:43 +0100
Message-ID: <20240220205647.005175240@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beau Belgrave <beaub@linux.microsoft.com>

commit 5eaf7f0589c0d88178f0fbeebe0e0b7108258707 upstream.

Eventfs uses simple_lookup(), however, it will fail if the name of the
entry is beyond NAME_MAX length. When this error is encountered, eventfs
still tries to create dentries instead of skipping the dentry creation.
When the dentry is attempted to be created in this state d_wait_lookup()
will loop forever, waiting for the lookup to be removed.

Fix eventfs to return the error in simple_lookup() back to the caller
instead of continuing to try to create the dentry.

Link: https://lore.kernel.org/linux-trace-kernel/20231210213534.497-1-beaub@linux.microsoft.com

Fixes: 63940449555e ("eventfs: Implement eventfs lookup, read, open functions")
Link: https://lore.kernel.org/linux-trace-kernel/20231208183601.GA46-beaub@linux.microsoft.com/
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -546,6 +546,8 @@ static struct dentry *eventfs_root_looku
 		if (strcmp(ei_child->name, name) != 0)
 			continue;
 		ret = simple_lookup(dir, dentry, flags);
+		if (IS_ERR(ret))
+			goto out;
 		create_dir_dentry(ei, ei_child, ei_dentry, true);
 		created = true;
 		break;
@@ -568,6 +570,8 @@ static struct dentry *eventfs_root_looku
 			if (r <= 0)
 				continue;
 			ret = simple_lookup(dir, dentry, flags);
+			if (IS_ERR(ret))
+				goto out;
 			create_file_dentry(ei, i, ei_dentry, name, mode, cdata,
 					   fops, true);
 			break;


