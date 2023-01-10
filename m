Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A666FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FD0C433F0;
	Tue, 10 Jan 2023 18:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374303;
	bh=wIJKBYaQ1VXqSBSFwrxCbb9ti8ZKJ7yZl0stDP+aba8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yivMUO5FqPfr89DqNsA3dVnQ9zu1qrOezBX7rRIMcIhmKlOllP61UmwQ0M4deW29H
	 /f6VAagIy/y/i+ghIYLH4h7O7ruQwBJ/0e/s9VFLiXcqOe5l+CHoHbKJcPdRf7rwKG
	 gDzSEX7xvJazNTad2bZ2YYTMyjAelaByc1fFGb3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Branco <bsdaemon@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.0 122/148] x86/bugs: Flush IBP in ib_prctl_set()
Date: Tue, 10 Jan 2023 19:03:46 +0100
Message-Id: <20230110180021.062132400@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Branco <bsdaemon@google.com>

commit a664ec9158eeddd75121d39c9a0758016097fa96 upstream.

We missed the window between the TIF flag update and the next reschedule.

Signed-off-by: Rodrigo Branco <bsdaemon@google.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1951,6 +1951,8 @@ static int ib_prctl_set(struct task_stru
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
 		task_update_spec_tif(task);
+		if (task == current)
+			indirect_branch_prediction_barrier();
 		break;
 	default:
 		return -ERANGE;


