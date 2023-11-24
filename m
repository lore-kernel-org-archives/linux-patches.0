Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B133075;
	Fri, 24 Nov 2023 18:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chUm8m1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC78C433C7;
	Fri, 24 Nov 2023 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851301;
	bh=EMY/6YvJ6nJAM3b51vbwyQ7ogaT5B/ZbocWIHT7Typ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chUm8m1JZZDsoRO41LY0j/nzAePTWzx0C4kXi93TZrC2KtvTflf5ogzydODeT5E8T
	 lm1rPzz6hb5UTE6yHN7Q51q583hFfKmQr1XQWrd29pTye6+nocox6oaQsE/nbElVn+
	 kJ/ONtSzDZJt69eykQ2uFpc1jhfWcjfMZXcnusGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.5 394/491] cifs: force interface update before a fresh session setup
Date: Fri, 24 Nov 2023 17:50:30 +0000
Message-ID: <20231124172036.449051049@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit d9a6d78096056a3cb5c5f07a730ab92f2f9ac4e6 upstream.

During a session reconnect, it is possible that the
server moved to another physical server (happens in case
of Azure files). So at this time, force a query of server
interfaces again (in case of multichannel session), such
that the secondary channels connect to the right
IP addresses (possibly updated now).

Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3850,8 +3850,12 @@ cifs_setup_session(const unsigned int xi
 	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
 	spin_unlock(&ses->chan_lock);
 
-	if (!is_binding)
+	if (!is_binding) {
 		ses->ses_status = SES_IN_SETUP;
+
+		/* force iface_list refresh */
+		ses->iface_last_update = 0;
+	}
 	spin_unlock(&ses->ses_lock);
 
 	/* update ses ip_addr only for primary chan */


