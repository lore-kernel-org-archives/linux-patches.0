Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D303A3CDBDD;
	Tue, 12 May 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607882; cv=none; b=mMHNOdtuHtt4lRvJPv8msaBdlQelqVzJlk5XPA0M02zvdx3sG+G5uHLDWzSJPUWoImBQm9xYOFszs4IdGsY3+FnvrrLsEiwQkrPIXZbB5eIU6XEaBfUxZ/h+GOBigCFCO22EFoCrKLQ8OrLxcCotYmArLXEFMdwfZ1kjJTM5g54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607882; c=relaxed/simple;
	bh=sMj4XVx1h0HhREkfgUEgRMBIR+LHu59Eb3BcchQ2WLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtQ7Hqf0ynyhk/ZbNVeQJK1nZ0uq6a/KRcvYUKCQ3XWpG8BSzURH8qqtPAptRCU5DYJPeaOd1gPi8ka9x6nuJOpUfGZaP+dOsF4t8QX1NUWsU5L0LOA7MyY6DyOw98PsfkZlG+PjIZFJnjrmn37Vn4OHJK3baI/N15bFMDTFYgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSNHWn7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSNHWn7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29912C2BCB0;
	Tue, 12 May 2026 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607882;
	bh=sMj4XVx1h0HhREkfgUEgRMBIR+LHu59Eb3BcchQ2WLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSNHWn7JoYK42+VZh2Xqyo1VEfyZKzU3uLIWSmELjz5ld3AoQdkSyxZRcf/BXaVXh
	 j433M3iXNUnNBleKYXMpjEy8EyxFgIUfdR4PGW7HE07BVE78p/5gOpaMIh6QeZhAbF
	 7fYTA3RU86Fq8oEIdkXPf8hAF+pwTcAPZHbOIQZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martyn Welch <martyn@welchs.me.uk>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 073/206] staging: vme_user: fix root device leak on init failure
Date: Tue, 12 May 2026 19:38:45 +0200
Message-ID: <20260512173934.395107076@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 32c91e8ee039777d0b95b914633fc6a42607959c upstream.

Make sure to deregister and free the root device in case module
initialisation fails.

Fixes: 658bcdae9c67 ("vme: Adding Fake VME driver")
Cc: stable@vger.kernel.org	# 4.9
Cc: Martyn Welch <martyn@welchs.me.uk>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260424104910.2619349-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vme_user/vme_fake.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/vme_user/vme_fake.c
+++ b/drivers/staging/vme_user/vme_fake.c
@@ -1230,6 +1230,8 @@ err_master:
 err_driver:
 	kfree(fake_bridge);
 err_struct:
+	root_device_unregister(vme_root);
+
 	return retval;
 }
 


