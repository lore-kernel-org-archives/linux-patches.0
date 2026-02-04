Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DD4237A4F;
	Wed,  4 Feb 2026 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217220; cv=none; b=oVtwR8+noZfQXJkiRup62Ajgx64wSPlYZUZZaTDrCtfiCC3nfgPbEt8RNUMevpGQvsh7ZJNlGNddAd7iZqOlpy95A+nwdrbKq4SoJem3yrXRMigNa7OJ3+E6QlArInETLnxB3Cu8M4h97yDlVrw+xgFUE3W//v8GKTzzwUUF+0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217220; c=relaxed/simple;
	bh=ZGWhr14wUGxFdwwLG3eERbq90EFYWGlPUfSXWo1VAo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=midok5ZB/HwglJsUJJJNj6+sQCdD53fwXBGtgdkIpBl+u2y+qlanuptKy+h45owUwF41d+OIYOUfu8Y1wQ8Pl5dEfTyDmbhUuwuFQQfqci7eB9BFds/lMpF6I1LWUwPaqfKl8t54icpieaiGIUXsZn5WAIEfq9VhdHRtt34kn8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yD/SciB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yD/SciB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0779C4CEF7;
	Wed,  4 Feb 2026 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217220;
	bh=ZGWhr14wUGxFdwwLG3eERbq90EFYWGlPUfSXWo1VAo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yD/SciB5+vrC2Jfe9NbLYQdQXpIonX901j48Sc72c2OO1H+X4XkQqBJR9ok8EL/c
	 r+NDeHJtNOmKN7avcX+QZ8hOE0KSsQkeTm8LR6Ymz2ctfX6298ptdPBnhzmrk+DBHQ
	 4HTanznj5OAmPgi+Bp674exelFRmi1vzY+u23FME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 158/206] of: platform: Use default match table for /firmware
Date: Wed,  4 Feb 2026 15:39:49 +0100
Message-ID: <20260204143903.894917836@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

commit 48e6a9c4a20870e09f85ff1a3628275d6bce31c0 upstream.

Calling of_platform_populate() without a match table will only populate
the immediate child nodes under /firmware. This is usually fine, but in
the case of something like a "simple-mfd" node such as
"raspberrypi,bcm2835-firmware", those child nodes will not be populated.
And subsequent calls won't work either because the /firmware node is
marked as processed already.

Switch the call to of_platform_default_populate() to solve this problem.
It should be a nop for existing cases.

Fixes: 3aa0582fdb82 ("of: platform: populate /firmware/ node from of_platform_default_populate_init()")
Cc: stable@vger.kernel.org
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://patch.msgid.link/20260114015158.692170-2-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -533,7 +533,7 @@ static int __init of_platform_default_po
 
 	node = of_find_node_by_path("/firmware");
 	if (node) {
-		of_platform_populate(node, NULL, NULL, NULL);
+		of_platform_default_populate(node, NULL, NULL);
 		of_node_put(node);
 	}
 


