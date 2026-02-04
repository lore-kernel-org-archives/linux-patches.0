Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07B73AEF30;
	Wed,  4 Feb 2026 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216671; cv=none; b=H1cjVwu991JQ/1jaZKJ5i7J0I6JPk4Fq7xj+TEvytjrmXqWD+0JgkffeA3i/Gy0PL4s2+xq3FfZIEByE6Q7wzByonDvkXWsG285kkpp04ABlgzlDzHQc0Ukf/fwx7kmPPWLzWUW78Q9B65kAEfg7JD4KMBBklkHu+x16+5+kzyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216671; c=relaxed/simple;
	bh=MLtv9w73XCv5wjFqzSEdYTj9nI1T7tM4UJn4PbpzS+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip9eJ+4SLAzWzFSGPQjQUzqwj4UVynIPj0HnLqa1gwlzAoI0qdszQPcRWDeBhh3N0XFW2HjVhmayOCUlf2nWiQpBDli5SftCHb43DLOWPZySZTwuFkxY+sYiOcSyMtDS340BuzOS3JaYw+SMxSd1ZTpU9QJFVKFajLNmkrldbVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pa71ureN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pa71ureN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DEEC4CEF7;
	Wed,  4 Feb 2026 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216671;
	bh=MLtv9w73XCv5wjFqzSEdYTj9nI1T7tM4UJn4PbpzS+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pa71ureNA4ZFsmpqTGEWBa/k6WdsrOlmQ+Qi4wktDLhYMT2napMyratFfzAJCbZwq
	 mIJbLBVhugq3lOB+5CJVwJbOC67Sb7K4yy+frTISD8gMN75O5HITFctkrmdgJSL/2e
	 1F93ddnCjpDH7239ny4VV8qVPM6ijUtnmlyXZQTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Wenshan Lan <jetlan9@163.com>
Subject: [PATCH 5.10 158/161] HID: uclogic: Add NULL check in uclogic_input_configured()
Date: Wed,  4 Feb 2026 15:40:21 +0100
Message-ID: <20260204143857.433415105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit bd07f751208ba190f9b0db5e5b7f35d5bb4a8a1e ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
uclogic_input_configured() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: dd613a4e45f8 ("HID: uclogic: Correct devm device reference for hidinput input_dev name")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ Adjust context ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-uclogic-core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -143,9 +143,12 @@ static int uclogic_input_configured(stru
 		break;
 	}
 
-	if (suffix)
+	if (suffix) {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
+		if (!hi->input->name)
+			return -ENOMEM;
+	}
 
 	return 0;
 }


