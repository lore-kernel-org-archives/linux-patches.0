Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BE64657E7;
	Tue, 16 Jun 2026 16:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626136; cv=none; b=taJ80PuFTD0Yorf1Qurv8dulJdfGLiFmt0fn5UGUdPfyM77cOfpV79+HgNO2qvKXWFy38bbQqe9KRrjf32bRvqCSpDHRwEoyfcEvQua5k7UXgHuN4j4iKhbfBFmzZivFEYwXHXmG9RlSKib82W8etk6QlPxjFxZEawjIPvtumxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626136; c=relaxed/simple;
	bh=ydIjZr/TBCz1ZCDbrrjT4D7BuXM/ZkmgwTeRFfw85+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTcoLMOdIOktmn8Obr39uKipsCKQIpq4PlUm/RO0VZ1VWZE2CD6gx7rlG1nNGiY5tPXf0y4gil0WgzC7i7HnvxlMpVvlnSm4Ea0CHPUe9WcKaGaPmmT07hR2IH2dmlghWefm9/tayGy2t6FkeIoH4yRWS3qtItkVzOO5df2u5ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GR8+9G3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GR8+9G3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75241F000E9;
	Tue, 16 Jun 2026 16:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626134;
	bh=ynblNsS3RGz/XFfFeD+aPMYWeODwWWWhA2fkBcRPW7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GR8+9G3u4QGCeYL9cYHEAowW9/6Wah0FzJPiH6P17C3iFporQT+vV6f4Vl9zudCB7
	 UH7Q0lmyaJglpquh9y8WF7jveYiNsErvXGe7ZAofrpqMA/0JB/rNJfJs7+PvEBoqS0
	 WFnwp1b4hkOfcFP1+O8LeIUQ3l4fXvhQykyBIoB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 270/325] thunderbolt: Bound root directory content to block size
Date: Tue, 16 Jun 2026 20:31:06 +0530
Message-ID: <20260616145112.113445061@linuxfoundation.org>
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


