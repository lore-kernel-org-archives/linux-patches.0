Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AC0472798;
	Tue, 16 Jun 2026 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627643; cv=none; b=oZvshASBLxdVpGy0pzcQ50ppnAUN0iTV7RnlxchR66tbqLMgMCNevXKhAPQNxJ+MwLnWoZQ2ThM7/Gpv10wbcdDtMqKZg5h63JpfUd8A5Wp6/lXlyBN75h/yq4rFLgbOv5JjC9VYfOOI6YpurVS/odlBpqVo3YN3mX4/VeRYxdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627643; c=relaxed/simple;
	bh=loPCuwSYZtB8K89Ef+YaMya40h2QACehMkhzkStCibY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sg1tEvS7KR5McundV5E/JJhSihjwWU0nD26eK//JN0tlwDXR9ZiPdplr03KFh3VG3vx3hAVo5Cnuf8JHblDFj3jxsaMVEzoc0/beYlzldmtL0k6H2QgJ8SqpGBusR2mQPuJ+CetjdC4Ud1Yjd7UvZ5/qawQLZVEN1woQsxAebqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTD4/JxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTD4/JxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977781F000E9;
	Tue, 16 Jun 2026 16:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627642;
	bh=rR7f8vdK8sLiZXA7a4TxmtxTQefNk63vVm7tj6JKpEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTD4/JxZ4JtAB+lkgs5OdqTY9HpeeFqRvmL4V+dSM2BmA9uAJf+FSE82TFSsmspz2
	 tl8TF7ptUM6kUtjtt0ISTS/R+Sl1S/MizxTUL4d9lueY+Aj8PHv3j7LqPzGla92p9K
	 5ti4LTC+m08a0DMTmrtigmFwzJiIJn0quPlyYyI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 203/261] thunderbolt: Bound root directory content to block size
Date: Tue, 16 Jun 2026 20:30:41 +0530
Message-ID: <20260616145054.457661506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 65423079c7420e3dbf9a7aa345c243a3f5752e5d upstream.

__tb_property_parse_dir() does not check that content_offset +
content_len fits within block_len for the root directory case.
When rootdir->length equals or exceeds block_len - 2, the entry
loop reads past the allocated property block.

Add a bounds check after computing content_offset and content_len
to reject directories whose content extends past the block.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/property.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/property.c
+++ b/drivers/thunderbolt/property.c
@@ -187,6 +187,10 @@ static struct tb_property_dir *__tb_prop
 	if (is_root) {
 		content_offset = dir_offset + 2;
 		content_len = dir_len;
+		if (content_offset + content_len > block_len) {
+			tb_property_free_dir(dir);
+			return NULL;
+		}
 	} else {
 		if (dir_len < 4) {
 			tb_property_free_dir(dir);


