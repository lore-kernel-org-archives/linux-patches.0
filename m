Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3A731E85C;
	Thu, 16 Jul 2026 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209530; cv=none; b=OZjLvEsUtVuvU2+a+bHYi8IuDYnbq8oB4o5M+WpVrTgoqMebgZRND131JGr/PYM2LJypxfIgIK0CszciGOv2miuuoCO11gO7Ez//wB4WvVZ2OFSQvhRJOKcG93cL0y9XG1RWbM2lMNlYi+h8/hyXyYeDxWsQHGl4XQHYQK0bka0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209530; c=relaxed/simple;
	bh=529HJjFXw/bk0erZ89SfXuizA7Gr/HBJmoLUXJ855C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9Na0gN+GKB93ZJ28YOhoR9gQfO7OQ66zMvskamAahCFVJiIIXahWriAZtem7NLKxBvKOgsp3RV0gMCUwoNvoiSMN6OECEfKo4r97JARyMoJt3GNBRD+RRknJyVMnipo24cIY3Ih2dMnbsu/2T7yDf6wNQfzCpDXIN0kmYodFbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhHaL1xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhHaL1xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930FB1F000E9;
	Thu, 16 Jul 2026 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209529;
	bh=RbytxtiuEvzrvUJnFGzzGcgLiW83h9X3OTooPsbztsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhHaL1xP2HfIXkPy9OqaclvBv3g+HRn5B4ky3Ki3Jo3QbQ+gtC+cVm/nU2hI08t3A
	 IZnXkBK1yIkUiPFukNvQjfIlOY9DfqMxAg1OXA848rmGTJLEHXLZywAjL8ioYM1ft+
	 UwJ1bsuz9msl9OcMuaslVGUWNUazbG4cegIeL+bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 221/518] ksmbd: require source read access for duplicate extents
Date: Thu, 16 Jul 2026 15:28:09 +0200
Message-ID: <20260716133052.653507704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit cedff600f1642aa982178503552f0d007bc829c8 upstream.

FSCTL_DUPLICATE_EXTENTS_TO_FILE passes the source file directly to
vfs_clone_file_range() or vfs_copy_file_range() without checking the SMB
access mask granted to the source handle. A handle opened with attribute
access can consequently be used to copy file contents into an
attacker-readable destination.

Require FILE_READ_DATA on the source handle before either VFS operation,
matching other ksmbd data-copy paths.

Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8580,6 +8580,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 			ret = -EACCES;
 			goto dup_ext_out;
 		}
+		if (!(fp_in->daccess & FILE_READ_DATA_LE)) {
+			ret = -EACCES;
+			goto dup_ext_out;
+		}
 
 		src_off = le64_to_cpu(dup_ext->SourceFileOffset);
 		dst_off = le64_to_cpu(dup_ext->TargetFileOffset);


