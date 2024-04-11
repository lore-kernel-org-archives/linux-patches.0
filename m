Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F556BB29;
	Thu, 11 Apr 2024 10:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832283; cv=none; b=YedgB0ydZQahnut6SIhZlxaGyKiMaDB+WqCi1X8TSF35oSfqbdSmF5tZJw0y1p512BTs0GFwzt3KHv071c9oh/s5qpGq0c9xHSD4ONiaHTJO48Kq7Dnf+SFaIRaCuuRa7xYBLsbP9mq/6ErO3B5RmfSGCzn8idesAR4XRg9Zwus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832283; c=relaxed/simple;
	bh=SgWa6znbpwoHX2kJBorBmES38HFakoa4ZInLD3xdEwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0ljiShP43hpgjWcWTrKupeMOR/XRI7xZHEYg7zTs51vE4z2+PdtnXfbbrOBb6nyYcphJVAH+QyhSDMHlMq6moSJ/4PfcmfXM1jmCjt1TdKJcAS3ubwRDSMNccxLhgMdMz6LHyeNrx1OBIU8klE50007w5eTntjvQijL3Q2E/kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=to18QeIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="to18QeIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57060C433C7;
	Thu, 11 Apr 2024 10:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832283;
	bh=SgWa6znbpwoHX2kJBorBmES38HFakoa4ZInLD3xdEwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to18QeIUbI88N/D4BXOZfLe13mYGSemWPaGUsY8y+KNa7U/5HZASGXUgT7bOA7EBP
	 rPEbKCHYgUDjFHtri6FBBQklD+LOiPHIv1dpumvVoVbw/oYno8B2aamBhkitG9MPaZ
	 dGy0OJF1GX9dEsAmI0SqvjgiNJP/fyhtOcV9qknY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubecek <mkubecek@suse.cz>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 291/294] kbuild: dummy-tools: adjust to stricter stackprotector check
Date: Thu, 11 Apr 2024 11:57:34 +0200
Message-ID: <20240411095444.296508241@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kubecek <mkubecek@suse.cz>

commit c93db682cfb213501881072a9200a48ce1dc3c3f upstream.

Commit 3fb0fdb3bbe7 ("x86/stackprotector/32: Make the canary into a regular
percpu variable") modified the stackprotector check on 32-bit x86 to check
if gcc supports using %fs as canary. Adjust dummy-tools gcc script to pass
this new test by returning "%fs" rather than "%gs" if it detects
-mstack-protector-guard-reg=fs on command line.

Fixes: 3fb0fdb3bbe7 ("x86/stackprotector/32: Make the canary into a regular percpu variable")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/dummy-tools/gcc |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/dummy-tools/gcc
+++ b/scripts/dummy-tools/gcc
@@ -76,7 +76,11 @@ fi
 if arg_contain -S "$@"; then
 	# For scripts/gcc-x86-*-has-stack-protector.sh
 	if arg_contain -fstack-protector "$@"; then
-		echo "%gs"
+		if arg_contain -mstack-protector-guard-reg=fs "$@"; then
+			echo "%fs"
+		else
+			echo "%gs"
+		fi
 		exit 0
 	fi
 fi


