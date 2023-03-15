Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895D64431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAA3C433D2;
	Wed, 15 Mar 2023 12:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883090;
	bh=fFxqEhm8dXNgEEsfJ8IsbnkMeIDNMJOncIRmJ4/BUHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw0zvRhnT1Z7NmaBLpZFnHLOAD+0yw2YdShBxelbvLIXxOx1Tc0DKalet154uRy+9
	 +AP0lKM7CwuKM9O6htqqj5rmK12mzD+zD0tpmZIsyF3HKGJSvi1JL41Zdde6sHf6N7
	 ojWYec0F5DsDLqRAlcapLT6/kekrJT7m2CUZxaS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vagin <avagin@openvz.org>,
	Christian Brauner <brauner@kernel.org>,
	Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH 5.15 004/145] fork: allow CLONE_NEWTIME in clone3 flags
Date: Wed, 15 Mar 2023 13:11:10 +0100
Message-Id: <20230315115739.123920723@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Klauser <tklauser@distanz.ch>

commit a402f1e35313fc7ce2ca60f543c4402c2c7c3544 upstream.

Currently, calling clone3() with CLONE_NEWTIME in clone_args->flags
fails with -EINVAL. This is because CLONE_NEWTIME intersects with
CSIGNAL. However, CSIGNAL was deprecated when clone3 was introduced in
commit 7f192e3cd316 ("fork: add clone3"), allowing re-use of that part
of clone flags.

Fix this by explicitly allowing CLONE_NEWTIME in clone3_args_valid. This
is also in line with the respective check in check_unshare_flags which
allow CLONE_NEWTIME for unshare().

Fixes: 769071ac9f20 ("ns: Introduce Time Namespace")
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2829,7 +2829,7 @@ static bool clone3_args_valid(struct ker
 	 * - make the CLONE_DETACHED bit reusable for clone3
 	 * - make the CSIGNAL bits reusable for clone3
 	 */
-	if (kargs->flags & (CLONE_DETACHED | CSIGNAL))
+	if (kargs->flags & (CLONE_DETACHED | (CSIGNAL & (~CLONE_NEWTIME))))
 		return false;
 
 	if ((kargs->flags & (CLONE_SIGHAND | CLONE_CLEAR_SIGHAND)) ==


