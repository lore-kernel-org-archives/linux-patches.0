Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9B72210FB;
	Thu, 12 Dec 2024 15:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018611; cv=none; b=SV7WEMf6lMTIaZA08GlreUIhcVUtk0NW+Mp0UrQDxvM+OIYOnPguGxdPhvAzsnULolSjrHhL5I7RPzd8GxZNba3cQQbNtLYPF8MczlEd63PmVdMpvpyOY/dlBCA0TlSJEw7lPhyvxR6NN2MbwedZRIML10IfrgInza3bKVBKimM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018611; c=relaxed/simple;
	bh=E6BsVLpP57zn2tC6USyo0FyICZmbWd/SiXOWcZTD/9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwVbo+i3ZRot2IP/tS1peGOxOzeBZQ4LwlO8lfg/bhzn8kQ4s6Gdq6kUAY8WrcZAeEBpGTe7N5cJ+rbEfnqRHGSM9ao+0RpdopSJVx5cnhvANnaP9TZ/eJt2SlBVRyaFMzGdW/shz6HJQ4lBVtmDLystLvfCRB1Q4JXzpLdb1SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5JR+xrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5JR+xrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191E4C4CECE;
	Thu, 12 Dec 2024 15:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018611;
	bh=E6BsVLpP57zn2tC6USyo0FyICZmbWd/SiXOWcZTD/9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5JR+xrwIQhxhN81Eq6UJvPMFr9sNdS2+AnMq9/DYoO+DwwCl3nEgx9kRyFs1IMQR
	 or0kB7MFWrvQajpGlTZ1+hEE/Y7It097YgPBhyqAtM1tyGdGszqNQ/0V+9tT5Xk3Su
	 +FGfIHjOKdS28s3EHqNXvyvkErrJ5umMrwj/iLSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kinsey Moore <kinsey.moore@oarcorp.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.6 340/356] jffs2: Prevent rtime decompress memory corruption
Date: Thu, 12 Dec 2024 16:00:59 +0100
Message-ID: <20241212144258.002255334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kinsey Moore <kinsey.moore@oarcorp.com>

commit fe051552f5078fa02d593847529a3884305a6ffe upstream.

The rtime decompression routine does not fully check bounds during the
entirety of the decompression pass and can corrupt memory outside the
decompression buffer if the compressed data is corrupted. This adds the
required check to prevent this failure mode.

Cc: stable@vger.kernel.org
Signed-off-by: Kinsey Moore <kinsey.moore@oarcorp.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jffs2/compr_rtime.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/jffs2/compr_rtime.c
+++ b/fs/jffs2/compr_rtime.c
@@ -95,6 +95,9 @@ static int jffs2_rtime_decompress(unsign
 
 		positions[value]=outpos;
 		if (repeat) {
+			if ((outpos + repeat) >= destlen) {
+				return 1;
+			}
 			if (backoffs + repeat >= outpos) {
 				while(repeat) {
 					cpage_out[outpos++] = cpage_out[backoffs++];


