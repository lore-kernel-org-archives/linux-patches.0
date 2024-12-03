Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4521F473A;
	Tue,  3 Dec 2024 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239643; cv=none; b=sMmOm34yDRtcUfHhOq/Iu56KPHaJLvHncCiA7OKO8Sw17bBadLQ9jGcz+1FUE2WF8luskiYVQ0vEAel3ntoQHZceM43gp7/ImANAVF/CANKznGGnK2x00l3pZ+pH8WDKeF4hkPLh7V0sTX18zs+D7ykhvNG2CjZUEaYTysUq9qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239643; c=relaxed/simple;
	bh=C/8njtmz84ay3YkXm8PR1SUPBhlGMkZXJTqKs21zWk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+ja4NCtNCbdvb0pwuwrmVh6Nzj7gE3KIZBqFIPVRbt5ZBN2/2BCSOnS5M3am7lViJcd5Y1HTT66oPMtt8pcZWUnAqS2b/wg9crJbccVbX1Skhj0gUEDa7RMn8n8jIY07AKaZAlY1beRFLCYNXrvTyL+ca/hDoJAoa0aXISfvOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3GcTaci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3GcTaci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CC8C4CECF;
	Tue,  3 Dec 2024 15:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239643;
	bh=C/8njtmz84ay3YkXm8PR1SUPBhlGMkZXJTqKs21zWk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3GcTacieI++kSOU4TKwqnFh7w3SpPrYSL7PltuE/m8yAIFpORlusaZrzAVympMfL
	 VpbLQzlV5n8dI/zVTSIa4HO1lTSHVQoPJXmdrEJxiEcgU+6M696GImNEXvxyJDe8Dm
	 mOr53RfHHd3JstEOtOWz6/fkTZegExi8Mo/vDQdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrej Shadura <andrew.shadura@collabora.co.uk>,
	Nathan Chancellor <nathan@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Aleksei Vetrov <vvvvvv@google.com>
Subject: [PATCH 6.11 677/817] Bluetooth: Fix type of len in rfcomm_sock_getsockopt{,_old}()
Date: Tue,  3 Dec 2024 15:44:09 +0100
Message-ID: <20241203144022.383156412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrej Shadura <andrew.shadura@collabora.co.uk>

commit 5fe6caa62b07fd39cd6a28acc8f92ba2955e11a6 upstream.

Commit 9bf4e919ccad worked around an issue introduced after an innocuous
optimisation change in LLVM main:

> len is defined as an 'int' because it is assigned from
> '__user int *optlen'. However, it is clamped against the result of
> sizeof(), which has a type of 'size_t' ('unsigned long' for 64-bit
> platforms). This is done with min_t() because min() requires compatible
> types, which results in both len and the result of sizeof() being casted
> to 'unsigned int', meaning len changes signs and the result of sizeof()
> is truncated. From there, len is passed to copy_to_user(), which has a
> third parameter type of 'unsigned long', so it is widened and changes
> signs again. This excessive casting in combination with the KCSAN
> instrumentation causes LLVM to fail to eliminate the __bad_copy_from()
> call, failing the build.

The same issue occurs in rfcomm in functions rfcomm_sock_getsockopt and
rfcomm_sock_getsockopt_old.

Change the type of len to size_t in both rfcomm_sock_getsockopt and
rfcomm_sock_getsockopt_old and replace min_t() with min().

Cc: stable@vger.kernel.org
Co-authored-by: Aleksei Vetrov <vvvvvv@google.com>
Improves: 9bf4e919ccad ("Bluetooth: Fix type of len in {l2cap,sco}_sock_getsockopt_old()")
Link: https://github.com/ClangBuiltLinux/linux/issues/2007
Link: https://github.com/llvm/llvm-project/issues/85647
Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -729,7 +729,8 @@ static int rfcomm_sock_getsockopt_old(st
 	struct sock *l2cap_sk;
 	struct l2cap_conn *conn;
 	struct rfcomm_conninfo cinfo;
-	int len, err = 0;
+	int err = 0;
+	size_t len;
 	u32 opt;
 
 	BT_DBG("sk %p", sk);
@@ -783,7 +784,7 @@ static int rfcomm_sock_getsockopt_old(st
 		cinfo.hci_handle = conn->hcon->handle;
 		memcpy(cinfo.dev_class, conn->hcon->dev_class, 3);
 
-		len = min_t(unsigned int, len, sizeof(cinfo));
+		len = min(len, sizeof(cinfo));
 		if (copy_to_user(optval, (char *) &cinfo, len))
 			err = -EFAULT;
 
@@ -802,7 +803,8 @@ static int rfcomm_sock_getsockopt(struct
 {
 	struct sock *sk = sock->sk;
 	struct bt_security sec;
-	int len, err = 0;
+	int err = 0;
+	size_t len;
 
 	BT_DBG("sk %p", sk);
 
@@ -827,7 +829,7 @@ static int rfcomm_sock_getsockopt(struct
 		sec.level = rfcomm_pi(sk)->sec_level;
 		sec.key_size = 0;
 
-		len = min_t(unsigned int, len, sizeof(sec));
+		len = min(len, sizeof(sec));
 		if (copy_to_user(optval, (char *) &sec, len))
 			err = -EFAULT;
 


