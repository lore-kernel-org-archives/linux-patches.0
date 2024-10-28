Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E789718E05A;
	Mon, 28 Oct 2024 06:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096921; cv=none; b=HQZzCSJuUZy2FrORcQSOjS6J96L+ji8Yw3ni+2+okkI2liQtBWbFhBWROixYCbVAliio1Nqw7rVHJROBPvvh1Sk7DQrvn6jYwoXv0CuIFzqlb0lZWjNOLQD/8q/KnxwVxwnAE/QvDU/3gFCs6eWF1KzuBQVYf2GZ3WyH+VTJhr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096921; c=relaxed/simple;
	bh=JgUpMWuqdBKJyJcXvHC51Hw9vrrxQ33mnNnwCu65bD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoeFyDL0F2satiSGNqtxNw6B+ULj2lqh95yFDQYLpF0rpeso3bG9ETmQuzlEsjgoOm9os4kZc/kwjFh4z9uXJVcMbzsbQSaPf21WGWUiveR4LM+mQf2snUhD/9SMp561Ig+XM56Ttani/ZgW8NM1JSziqiomqerfd/Vvm3eJPQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhElAPcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhElAPcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA81C4CEC3;
	Mon, 28 Oct 2024 06:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096920;
	bh=JgUpMWuqdBKJyJcXvHC51Hw9vrrxQ33mnNnwCu65bD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhElAPcV5j0fKp0mikTbWKetrqQgkMZW9Fe2x0Ghpx4q6IUUO+GY2m2nTt/1qcRyb
	 I0jHqNhDWDgVhiyD/m/4sv+2p1t05x4l7wdudVp3QWuffVmBeRzhIiojNUOpYYOwLD
	 KPanjqZve77Uk5ICfA4ZQ9t8PMI7LGJ/vVxb8fp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.com>,
	Gianfranco Trad <gianf.trad@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/80] udf: fix uninit-value use in udf_get_fileshortad
Date: Mon, 28 Oct 2024 07:25:25 +0100
Message-ID: <20241028062253.872212998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianfranco Trad <gianf.trad@gmail.com>

[ Upstream commit 264db9d666ad9a35075cc9ed9ec09d021580fbb1 ]

Check for overflow when computing alen in udf_current_aext to mitigate
later uninit-value use in udf_get_fileshortad KMSAN bug[1].
After applying the patch reproducer did not trigger any issue[2].

[1] https://syzkaller.appspot.com/bug?extid=8901c4560b7ab5c2f9df
[2] https://syzkaller.appspot.com/x/log.txt?x=10242227980000

Reported-by: syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8901c4560b7ab5c2f9df
Tested-by: syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com
Suggested-by: Jan Kara <jack@suse.com>
Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240925074613.8475-3-gianf.trad@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2100,12 +2100,15 @@ int8_t udf_current_aext(struct inode *in
 		alen = udf_file_entry_alloc_offset(inode) +
 							iinfo->i_lenAlloc;
 	} else {
+		struct allocExtDesc *header =
+			(struct allocExtDesc *)epos->bh->b_data;
+
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
-		alen = sizeof(struct allocExtDesc) +
-			le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->
-							lengthAllocDescs);
+		if (check_add_overflow(sizeof(struct allocExtDesc),
+				le32_to_cpu(header->lengthAllocDescs), &alen))
+			return -1;
 	}
 
 	switch (iinfo->i_alloc_type) {


