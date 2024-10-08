Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7031DE2A5;
	Tue,  8 Oct 2024 12:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391273; cv=none; b=KWHkAxEMFQNH11h7r8A0xXQ35c1mwanuuBIvP9ZQ2nT4MiYvWtS53U3Gip0yXJ9fOhG4nOp37Z3WSp/AtccFMdJMzzAXUj85BUWRHJhnY34G5d1q1BKzA0Q20vbQfwOEwtm7wB97TLXqdVjya2G/mm2/fMeBLg2RNM5GJGzkJ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391273; c=relaxed/simple;
	bh=4eem9MSPD6F8tdC8p1lHZZ8Yjl66EbDZD5M7lx+FOXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7R3IDLysYutYacU9XBv5o8rrnTG8/6jf9lgKaWJ4b/0FDrwAGDbHe9eXcWlZOKPbcIn7Hzg2CUmZfar7zvn35vR7ohzLgkBw/L0gnnl/e4Vxd3f7q72ZSL7kZejhoGyRvbhIs+4MH/LflWj54u3piAtvBu07npl9MWc+2i3uEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HS7cNKsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HS7cNKsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483B9C4CEC7;
	Tue,  8 Oct 2024 12:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391273;
	bh=4eem9MSPD6F8tdC8p1lHZZ8Yjl66EbDZD5M7lx+FOXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HS7cNKsJ0bacLXmkxMjD3++ffATAOlC+ZV14hTfBeNjE/njth45hkgzlP1d0wphY5
	 KLGWtzR1zGRdnQHgpSyD6onXLIccQOuFUZu6yH8ZqjlhlxmVXjUkSqNYRHeggK8my7
	 UAqkm/w6Eoz6qAJm6GokVSUbweFVMY1I/kgfpvWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor@kernel.org>,
	Dirk Behme <dirk.behme@de.bosch.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 062/558] rust: mutex: fix __mutex_init() usage in case of PREEMPT_RT
Date: Tue,  8 Oct 2024 14:01:32 +0200
Message-ID: <20241008115704.660244172@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Dirk Behme <dirk.behme@de.bosch.com>

[ Upstream commit d065cc76054d21e48a839a2a19ba99dbc51a4d11 ]

In case CONFIG_PREEMPT_RT is enabled __mutex_init() becomes a macro
instead of an extern function (simplified from
include/linux/mutex.h):

    #ifndef CONFIG_PREEMPT_RT
    extern void __mutex_init(struct mutex *lock, const char *name,
    			 struct lock_class_key *key);
    #else
    #define __mutex_init(mutex, name, key)		\
    do {						\
	rt_mutex_base_init(&(mutex)->rtmutex);		\
    	__mutex_rt_init((mutex), name, key);		\
    } while (0)
    #endif

The macro isn't resolved by bindgen, then. What results in a build
error:

error[E0425]: cannot find function `__mutex_init` in crate `bindings`
     --> rust/kernel/sync/lock/mutex.rs:104:28
      |
104   |           unsafe { bindings::__mutex_init(ptr, name, key) }
      |                              ^^^^^^^^^^^^ help: a function with a similar name exists: `__mutex_rt_init`
      |
     ::: rust/bindings/bindings_generated.rs:23722:5
      |
23722 | /     pub fn __mutex_rt_init(
23723 | |         lock: *mut mutex,
23724 | |         name: *const core::ffi::c_char,
23725 | |         key: *mut lock_class_key,
23726 | |     );
      | |_____- similarly named function `__mutex_rt_init` defined here

Fix this by adding a helper.

As explained by Gary Guo in [1] no #ifdef CONFIG_PREEMPT_RT
is needed here as rust/bindings/lib.rs prefers externed function to
helpers if an externed function exists.

Reported-by: Conor Dooley <conor@kernel.org>
Link: https://lore.kernel.org/rust-for-linux/20240913-shack-estate-b376a65921b1@spud/
Link: https://lore.kernel.org/rust-for-linux/20240915123626.1a170103.gary@garyguo.net/ [1]
Fixes: 6d20d629c6d8 ("rust: lock: introduce `Mutex`")
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240916073752.3123484-1-dirk.behme@de.bosch.com
[ Reworded to include the proper example by Dirk. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/helpers/mutex.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/rust/helpers/mutex.c b/rust/helpers/mutex.c
index 200db7e6279f0..a17ca8cdb50ca 100644
--- a/rust/helpers/mutex.c
+++ b/rust/helpers/mutex.c
@@ -7,3 +7,9 @@ void rust_helper_mutex_lock(struct mutex *lock)
 {
 	mutex_lock(lock);
 }
+
+void rust_helper___mutex_init(struct mutex *mutex, const char *name,
+			      struct lock_class_key *key)
+{
+	__mutex_init(mutex, name, key);
+}
-- 
2.43.0



