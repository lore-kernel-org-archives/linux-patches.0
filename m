Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E78C336EC9;
	Mon, 20 Apr 2026 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701220; cv=none; b=NAu6Xlb0RJIiyRzSTtBZMliEnjkDH5Aoy+ht/8b8B3dOGVxlAqRbocPwtkB6Xt64FGQnZbhnSOm5YUjnxXlG1iV/knSRzjvRaISRZijND9zftUI9KOL60jJshyMpTHFmyRW1E+KzmJ7bjmgrUKHa8oo40hUcnY8dIgBIaFRdJPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701220; c=relaxed/simple;
	bh=q1v77C63SOQYAD08in4vlPHUFfEIIlzBD554e7HRhYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JblAolsuSb5a7Lxwk0Qapqfh5NtFJpgr4tXZZ3/6zvssXxK/sAUe3zn67ThURkV+/Wmz5jssTj/LqaYxTO8CqJ2O5zWtKPTvCqPAjCgoYfCDfM942ZnxBYefEeVKbCI2UN09KihAwKZgEd4o6KUXO4F1otM9I9w24s9tAthxBcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsviFPUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsviFPUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7610C19425;
	Mon, 20 Apr 2026 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701220;
	bh=q1v77C63SOQYAD08in4vlPHUFfEIIlzBD554e7HRhYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsviFPUsoFyyM8edhE6LZiSKfMLsJDZfE/0ohPzQ8AIcMku6sGOddcW7LhjWhta6N
	 ZNqsXCBLPt0o/uxNXG9kFEA1gK25vfUQY/Ki6L2rN7xjsTkxXPCSp2g8YV9F1/GtKt
	 kcdLJbjSiZROWxVdrOlEUyTBXuHv6RJ4h74Gd1BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/162] HID: roccat: fix use-after-free in roccat_report_event
Date: Mon, 20 Apr 2026 17:41:01 +0200
Message-ID: <20260420153928.075327858@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit d802d848308b35220f21a8025352f0c0aba15c12 ]

roccat_report_event() iterates over the device->readers list without
holding the readers_lock. This allows a concurrent roccat_release() to
remove and free a reader while it's still being accessed, leading to a
use-after-free.

Protect the readers list traversal with the readers_lock mutex.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-roccat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index c7f7562e22e56..e413662f75082 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -257,6 +257,7 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->readers_lock);
 	mutex_lock(&device->cbuf_lock);
 
 	report = &device->cbuf[device->cbuf_end];
@@ -279,6 +280,7 @@ int roccat_report_event(int minor, u8 const *data)
 	}
 
 	mutex_unlock(&device->cbuf_lock);
+	mutex_unlock(&device->readers_lock);
 
 	wake_up_interruptible(&device->wait);
 	return 0;
-- 
2.53.0



