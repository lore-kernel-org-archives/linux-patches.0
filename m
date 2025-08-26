Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170B82BF3E2;
	Tue, 26 Aug 2025 11:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207781; cv=none; b=bgr2tWUiQrkAde1xIfZMrbwxGawa/2e9sIca2cLnvlUfKWf1AFfDccgUxYJe2OtvZ/yd4UKbW4aM6z2GNrSa+Cb3rpzBew4sS9YLusWRQTRsUqPDky0HsoGfgPWrf48xr2nUfBYSOVAEPpe91WFmxvZatnXPpANVUpMjC5FUdWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207781; c=relaxed/simple;
	bh=gw5Lyfs/MM0xavlkWdOP+HsFr2jUzJh/em441E86FFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScsAJ0EOlVNFkvpQmwpvCcd23WopFehBX1R97TxNOHGVjEZZgcZDWwdLX8lhYkH2iR5+SEwm3WcEkwYEOVEvbKDhTyJ79DQZCWJpFfpi0LDSQ0yRiD97Ov6YHYzOsepTHAru8m0eNoU3NK3c8EP1ayNXpVocbwhU7ke+96lxgLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/72DfNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/72DfNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA5EC4CEF1;
	Tue, 26 Aug 2025 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207781;
	bh=gw5Lyfs/MM0xavlkWdOP+HsFr2jUzJh/em441E86FFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/72DfNWTSkzFrC2ghMKigWOGrrpEDDk40yge0H/AUpxbtvinoCyXkP1PT1eWaCX5
	 nPAi5ciRXqTUWAeGWmnLE+THGIcB3W1WT9UUpaYnOXZgG7g5T69hfphLE56I4lYp4t
	 Yk3zHFTNuNJWGVe1NEkTFAsKgEEg2c50d2cR6ZNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bertschinger <tahbertschinger@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 284/457] fhandle: do_handle_open() should get FD with user flags
Date: Tue, 26 Aug 2025 13:09:28 +0200
Message-ID: <20250826110944.397879379@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bertschinger <tahbertschinger@gmail.com>

[ Upstream commit b5ca88927e353185b3d9ac4362d33e5aeb25771f ]

In f07c7cc4684a, do_handle_open() was switched to use the automatic
cleanup method for getting a FD. In that change it was also switched
to pass O_CLOEXEC unconditionally to get_unused_fd_flags() instead
of passing the user-specified flags.

I don't see anything in that commit description that indicates this was
intentional, so I am assuming it was an oversight.

With this fix, the FD will again be opened with, or without, O_CLOEXEC
according to what the user requested.

Fixes: f07c7cc4684a ("fhandle: simplify error handling")
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
Link: https://lore.kernel.org/20250814235431.995876-4-tahbertschinger@gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fhandle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 66ff60591d17..e21ec857f2ab 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -404,7 +404,7 @@ static long do_handle_open(int mountdirfd, struct file_handle __user *ufh,
 	if (retval)
 		return retval;
 
-	CLASS(get_unused_fd, fd)(O_CLOEXEC);
+	CLASS(get_unused_fd, fd)(open_flag);
 	if (fd < 0)
 		return fd;
 
-- 
2.50.1



